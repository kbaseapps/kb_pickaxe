########################################################################
# ModelSEED::MS::IndexedObject - This is the moose object corresponding to the IndexedObject object
# Author: Christopher Henry, Scott Devoid, and Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 3/11/2012
########################################################################

=head1 Bio::KBase::ObjectAPI::IndexedObject

=head2 METHODS

=head3 add

    $obj->add($attribute, $subobject);

Adds a sub-object C<$subobject> to the Indexed Object, updating
existing indexes to match the new object data.  C<$attribute> is a
string attribute name within the object.  C<$subobject> can be
either a plain perl hash or a C<ModelSEED::MS> object.

=head3 addAlias

    $obj->addAlias(\%config);

Add an alias to a AliasSet. Config is a hash reference that requires
the following parameters:

=over 4

=item attribute

The attribute that the aliases should be listed for, e.g.
"compounds", "reactions"

=item aliasName

The name of the alias class. For example, the Kyoto Encyclopedia
of Genes and Genomes (KEGG) reaction aliases are listed under "KEGG"

=item alias

A string. 

=item uuid

The uuid of the object to create an alias for.

=item source

This is optional, a string that is the source name for the object.
This defaults to "aliasName" if not supplied.

=back

=head3 getObjectByAlias 

	$aliased = $obj->getObjectByAlias($attribute,$alias,$aliasSet);
    $aliased = $obj->getObjectByAlias("compounds", "cpd01234", "ModelSEED");

Return the first object that is matched by the provided alias.
C<$attribute> is the attribute name for which the alias would apply,
e.g. "compounds", "roles", or "reactions".
C<$aliasName> is the class of alias to look for, e.g. "KEGG".
C<$alias> is the string to look for.

=head3 getObjectsByAlias

	\@aliased = $obj->getObjectByAlias($attribute,$alias,$aliasName);

Same as getObjectsByAlias, but will return an array-ref of all
aliases found.

=head3 getObject

    $found = $obj->getObject($attribute, $uuid)

Find an object that matches the provided C<$uuid>.  C<$attribute>
is the attribute name for which the object would be under. For
L<ModelSEED::MS::Biochemistry> this might be: "reactions", "compounds",
"media", etc.

If no object is found, return undef.

=head3 getObjects

    \@found = $obj->getObjects($attribute, $uuids)

Same as getObject, but C<$uuids> is an array ref of UUIDs and this
function returns an array ref of objects. If no objects are found,
return an empty list.

=head3 queryObject

    $found = $obj->queryObject($attribute, \%query);

Query for the first object that matches a specific set of attributes.
C<$attribute> follows the same format as above, the query is a hash
reference of attributes to values in the object that we are looking
for.

=head3 queryObjects

    \@found = $obj->queryObjects($attribute, \%query);

Same as queryObject except it returns all objects that match the
query parameters, not just the first one. This is returned as an
array reference.

=cut
package Bio::KBase::ObjectAPI::IndexedObject;
use Moose;
use Class::Autouse qw(
);
use Bio::KBase::ObjectAPI::utilities;
use namespace::autoclean;
use Bio::KBase::ObjectAPI::BaseObject;
extends 'Bio::KBase::ObjectAPI::BaseObject';

has indices => ( is => 'rw', isa => 'HashRef', default => sub { return {} } );
has wsmeta => (is => 'rw', lazy => 1, isa => 'ArrayRef', type => 'msdata', metaclass => 'Typed',default => sub { return [] });
has _wswsid => (is => 'rw', lazy => 1, isa => 'Num', type => 'msdata', metaclass => 'Typed',default => -1);
has _wsworkspace => (is => 'rw', lazy => 1, isa => 'Str', type => 'msdata', metaclass => 'Typed',default => "");
has _wschsum => (is => 'rw', lazy => 1, isa => 'Str', type => 'msdata', metaclass => 'Typed',default => "");
has _wssize => (is => 'rw', lazy => 1, isa => 'Num', type => 'msdata', metaclass => 'Typed',default => -1);
has _wsmeta => (is => 'rw', lazy => 1, isa => 'HashRef', type => 'msdata', metaclass => 'Typed',default => sub { return {} });
has _wsobjid => (is => 'rw', lazy => 1, isa => 'Num', type => 'msdata', metaclass => 'Typed',default => -1);
has _wsname => (is => 'rw', lazy => 1, isa => 'Str', type => 'msdata', metaclass => 'Typed',default => "");
has _wstype => (is => 'rw', lazy => 1, isa => 'Str', type => 'msdata', metaclass => 'Typed',default => "");
has _wssave_date => (is => 'rw', lazy => 1, isa => 'Str', type => 'msdata', metaclass => 'Typed',default => "");
has _wsversion => (is => 'rw', lazy => 1, isa => 'Num', type => 'msdata', metaclass => 'Typed',default => -1);
has _wssaved_by => (is => 'rw', lazy => 1, isa => 'Str', type => 'msdata', metaclass => 'Typed',default => "");

sub add {
    my ($self, $attribute, $data_or_object) = @_;
    my $attr_info = $self->_subobjects($attribute);
    if (!defined($attr_info)) {
        Bio::KBase::ObjectAPI::utilities::error("Object doesn't have subobject with name: $attribute");
    }
    my $ref = ref($data_or_object);
    my $data = $data_or_object;
    my $object = $data_or_object;
    if ($ref eq "HASH") {
    		foreach my $att (keys(%$data)) {
	        	if (!defined($data->{$att})) {
	        		delete $data->{$att};
	        	}
        }
        $object = $self->_build_object($data)
    } elsif ($ref =~ m/Bio::KBase::ObjectAPI/) {
    		$object->parent($self)
    		$data = $data_or_object->_data();
    } else {
    		Bio::KBase::ObjectAPI::utilities::error("Neither data nor object passed into " . ref($self) . "->add");
    }
    	push(@{$self->$attribute()},$object);
    push(@{$self->data()->{$attribute}},$data);
	#Updating the indices
	if (defined($self->indices->{$attribute})) {
		my $indices = $self->indices->{$attribute};
		foreach my $attribute (keys(%{$indices})) {
			if (defined($object->$attribute())) {
				push(@{$indices->{$attribute}->{$object->$attribute()}},$object);
			}
		}
	}
    return $object;
};

sub getObject {
    my ($self, $attribute, $id) = @_;
    my $objs = $self->getObjects($attribute, [$id]);
    if (scalar @$objs == 1) {
        return $objs->[0];
    } else {
        return;
    }
}

sub getObjects {
    my ($self, $attribute, $ids) = @_;
	#Checking arguments
	if(!defined($attribute) || !defined($ids) || ref($ids) ne 'ARRAY') {
    		Bio::KBase::ObjectAPI::utilities::error("Bad arguments to getObjects.");
    }
    #Retreiving objects
    my $results = [];
    if (!defined($self->indices->{$attribute}->{id})) {
    		$self->_buildIndex({attribute=>$attribute,subAttribute=>"id"});
    }
    my $index = $self->indices->{$attribute}->{id};
    foreach my $obj_id (@$ids) { 
		next if ! defined $obj_id;
        my $obj = $index->{$obj_id}->[0];
        if (defined($obj)) {
            push(@$results, $obj);
        } elsif (defined($self->_attributes("forwardedLinks")) && defined($self->forwardedLinks()->{$obj_id})) {
			push(@{$results},$self->getObject($attribute,$self->forwardedLinks()->{$obj_id}));
        } else {
            push(@$results, undef);
        }
    }
    return $results;
}

sub queryObject {
    my ($self,$attribute,$query) = @_;
    my $objs = $self->queryObjects($attribute,$query);
    if (defined($objs->[0])) {
        return $objs->[0];
    } else {
        return;
    }
}

sub queryObjects {
    my ($self,$attribute,$query) = @_;
	#Checking arguments
	if(!defined($attribute) || !defined($query) || ref($query) ne 'HASH') {
		Bio::KBase::ObjectAPI::utilities::error("Bad arguments to queryObjects.");
    }
    #ResultSet is a map of $object => $object
    my $resultSet;
    my $indices = $self->indices;
    while ( my ($subAttribute, $value) = each %$query ) {
        #Build the index if it does not already exist
        unless (defined($indices->{$attribute}) &&
                defined($indices->{$attribute}->{$subAttribute})) {
    		$self->_buildIndex({attribute => $attribute, subAttribute => $subAttribute});
    	}
        my $newHits = $indices->{$attribute}->{$subAttribute}->{$value};
        # If any index returns empty, return empty.
        return [] if(!defined($newHits) || @$newHits == 0);
        # Build the current resultSet map $object => $object
        my $newResultSet = { map { $_ => $_ } @$newHits };
        if(!defined($resultSet)) {
            # Use the current result set if %resultSet is empty,
            # which will only happen on the first time through the loop.
            $resultSet = $newResultSet; 
            next;
        } else {
			foreach my $result (keys(%$resultSet)) {
	            	if (!defined($newResultSet->{$result})) {
	            		delete $resultSet->{$result};
	            	}
            }
        }
    }
    my $results = [];
    foreach my $value (keys(%$resultSet)) {
    		push(@$results, $resultSet->{$value});
    }
    return $results;
}

sub save {
	my ($self,$ref,$params) = @_;
	$self->store()->save_object($self,$ref,$params);
}

sub _buildIndex {
    my $self = shift;
    my $args = Bio::KBase::ObjectAPI::utilities::args(["attribute","subAttribute"],{}, @_);
	my $att = $args->{attribute};
	my $subatt = $args->{subAttribute};
	my $newIndex  = {};
	if ($att =~ m/^682F57E0/) {
		Bio::KBase::ObjectAPI::utilities::error("Bad call to _buildIndex!");
	}
	if ($att eq "aliasSets") {
		Bio::KBase::ObjectAPI::utilities::error("Bad call to _buildIndex!");
	}
	my $method = "_$att";
	if ($method eq "_modelreactions" && $self->_class() eq "FBA") {
		Bio::KBase::ObjectAPI::utilities::error("Call to nonexistant method!");
	}
	my $subobjs = $self->$method();
	if (@{$subobjs} > 0) {
		#First we check if all objects need to be built before the index can be constructed
		my $obj = $self->_build_object($att,$subobjs->[0]);
		my $alwaysBuild = 1;
		if (defined($obj->_attributes($subatt))) {
			#The attribute is a base attribute, so we can build the index without building objects
			$alwaysBuild = 0;
		}
		foreach my $so_info (@{$subobjs}) {
			if ($alwaysBuild == 1) {
				$self->_build_object($att,$so_info);
			}
			my $data;
			if ($so_info->{created} == 1) {
				$data = $so_info->{object}->$subatt();
			} else {
				$data = $so_info->{data}->{$subatt};
			}
			if (ref($data) eq "ARRAY") {
				foreach my $item (@{$data}) {
					push(@{$newIndex->{$item}},$so_info);
				}
			} else {
				push(@{$newIndex->{$data}},$so_info);
			}
		}
	}
	$self->indices->{$att}->{$subatt} = $newIndex;
}

sub _clearIndex {
    my $self = shift;
    my $args = Bio::KBase::ObjectAPI::utilities::args([], {attribute => undef, subAttribute => undef}, @_);
	my $att = $args->{attribute};
	my $subatt = $args->{subAttribute};
	if (!defined($att)) {
		$self->indices({});
	} else {
		if (!defined($subatt)) {
			$self->indices->{$att} = {};	
		} else {
			$self->indices->{$att}->{$subatt} = {};
		}
	}
}

1;
