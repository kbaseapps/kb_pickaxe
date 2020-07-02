package kb_pickaxe::kb_pickaxeImpl;
use strict;
use Bio::KBase::Exceptions;
# Use Semantic Versioning (2.0.0-rc.1)
# http://semver.org 
our $VERSION = '1.3.1';
our $GIT_URL = 'ssh://git@github.com/kbaseapps/kb_pickaxe.git';
our $GIT_COMMIT_HASH = '0a0baf4023f3d16ba713f49b24dfb87de0b237bb';

=head1 NAME

kb_pickaxe

=head1 DESCRIPTION

A KBase module: kb_picaxe
This method wraps the PicAxe tool.

=cut

#BEGIN_HEADER
use fba_tools::fba_toolsImpl;
use Bio::KBase::AuthToken;
use Workspace::WorkspaceClient;
use Config::IniFiles;
#END_HEADER

sub new
{
    my($class, @args) = @_;
    my $self = {
    };
    bless $self, $class;
    #BEGIN_CONSTRUCTOR

    my $config_file = $ENV{ KB_DEPLOYMENT_CONFIG };
    my $cfg = Config::IniFiles->new(-file=>$config_file);
    my $wsInstance = $cfg->val('kb_pickaxe','workspace-url');
    die "no workspace-url defined" unless $wsInstance;
	$self->{'scratch'} = $cfg->val('kb_pickaxe','scratch');
	$self->{python_script_dir} = $cfg->val('kb_pickaxe','python_script_dir');
    $self->{'workspace-url'} = $wsInstance;

    print "Instantiating fba_tools\n";

    $self->{'callbackURL'} = $ENV{'SDK_CALLBACK_URL'};
    print "callbackURL is ", $self->{'callbackURL'}, "\n";
	$self->{fbaimpl} = fba_tools::fba_toolsImpl->new();
	Bio::KBase::kbaseenv::create_context_from_client_config();
	Bio::KBase::ObjectAPI::functions::set_handler($self->{fbaimpl});

    #END_CONSTRUCTOR

    if ($self->can('_init_instance'))
    {
	$self->_init_instance();
    }
    return $self;
}

=head1 METHODS



=head2 runpickaxe

  $return = $obj->runpickaxe($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a kb_pickaxe.RunPickAxe
$return is a kb_pickaxe.PickAxeResults
RunPickAxe is a reference to a hash where the following keys are defined:
	workspace has a value which is a kb_pickaxe.workspace_name
	model_id has a value which is a kb_pickaxe.model_id
	model_ref has a value which is a string
	rule_set has a value which is a string
	generations has a value which is an int
	prune has a value which is a string
	add_transport has a value which is an int
	out_model_id has a value which is a kb_pickaxe.model_id
	compounds has a value which is a reference to a list where each element is a kb_pickaxe.EachCompound
workspace_name is a string
model_id is a string
EachCompound is a reference to a hash where the following keys are defined:
	compound_id has a value which is a string
	compound_name has a value which is a string
PickAxeResults is a reference to a hash where the following keys are defined:
	model_ref has a value which is a string
	report_name has a value which is a string
	report_ref has a value which is a string

</pre>

=end html

=begin text

$params is a kb_pickaxe.RunPickAxe
$return is a kb_pickaxe.PickAxeResults
RunPickAxe is a reference to a hash where the following keys are defined:
	workspace has a value which is a kb_pickaxe.workspace_name
	model_id has a value which is a kb_pickaxe.model_id
	model_ref has a value which is a string
	rule_set has a value which is a string
	generations has a value which is an int
	prune has a value which is a string
	add_transport has a value which is an int
	out_model_id has a value which is a kb_pickaxe.model_id
	compounds has a value which is a reference to a list where each element is a kb_pickaxe.EachCompound
workspace_name is a string
model_id is a string
EachCompound is a reference to a hash where the following keys are defined:
	compound_id has a value which is a string
	compound_name has a value which is a string
PickAxeResults is a reference to a hash where the following keys are defined:
	model_ref has a value which is a string
	report_name has a value which is a string
	report_ref has a value which is a string


=end text



=item Description



=back

=cut

sub runpickaxe
{
    my $self = shift;
    my($params) = @_;

    my @_bad_arguments;
    (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"params\" (value was \"$params\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to runpickaxe:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'runpickaxe');
    }

    my $ctx = $kb_pickaxe::kb_pickaxeServer::CallContext;
    my($return);
    #BEGIN runpickaxe
    $params = $self->{fbaimpl}->util_initialize_call($params,$ctx);
	Bio::KBase::ObjectAPI::functions::func_run_pickaxe($params);
    $return = {};
    $self->{fbaimpl}->util_finalize_call({
		output => $return,
		workspace => $params->{workspace},
		report_name => $params->{out_model_id}.".pickaxe.report",
		model_ref => $params->{workspace}."/".$params->{out_model_id}
	});
    #END runpickaxe
    my @_bad_returns;
    (ref($return) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"return\" (value was \"$return\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to runpickaxe:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'runpickaxe');
    }
    return($return);
}




=head2 find_similar_modelseed_reactions

  $return = $obj->find_similar_modelseed_reactions($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a kb_pickaxe.find_similar_modelseed_reactions_params
$return is a kb_pickaxe.find_similar_modelseed_reactions_results
find_similar_modelseed_reactions_params is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	reaction_set has a value which is a reference to a list where each element is a string
	structural_similarity_floor has a value which is a float
	difference_similarity_floor has a value which is a float
	query_model_ref has a value which is a string
find_similar_modelseed_reactions_results is a reference to a hash where the following keys are defined:
	similar_reactions has a value which is a reference to a list where each element is a reference to a list containing 4 items:
		0: (similar_id) a string
		1: (query_id) a string
		2: (structural_similarity) a float
		3: (reactive_similarity) a float

	report_name has a value which is a string
	report_ref has a value which is a string

</pre>

=end html

=begin text

$params is a kb_pickaxe.find_similar_modelseed_reactions_params
$return is a kb_pickaxe.find_similar_modelseed_reactions_results
find_similar_modelseed_reactions_params is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	reaction_set has a value which is a reference to a list where each element is a string
	structural_similarity_floor has a value which is a float
	difference_similarity_floor has a value which is a float
	query_model_ref has a value which is a string
find_similar_modelseed_reactions_results is a reference to a hash where the following keys are defined:
	similar_reactions has a value which is a reference to a list where each element is a reference to a list containing 4 items:
		0: (similar_id) a string
		1: (query_id) a string
		2: (structural_similarity) a float
		3: (reactive_similarity) a float

	report_name has a value which is a string
	report_ref has a value which is a string


=end text



=item Description



=back

=cut

sub find_similar_modelseed_reactions
{
    my $self = shift;
    my($params) = @_;

    my @_bad_arguments;
    (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"params\" (value was \"$params\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to find_similar_modelseed_reactions:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'find_similar_modelseed_reactions');
    }

    my $ctx = $kb_pickaxe::kb_pickaxeServer::CallContext;
    my($return);
    #BEGIN find_similar_modelseed_reactions
    $self->{fbaimpl}->util_initialize_call($params,$ctx);
    my $model = $self->{fbaimpl}->util_get_object(Bio::KBase::utilities::buildref($params->{query_model_ref},$params->{workspace}));
    my $mdlrxns = $model->modelreactions();
    my $ms_rxn_hash = Bio::KBase::utilities::reaction_hash();
    my $reactionset = [split(/,/,$params->{reaction_set})];
    my $smartslist = {};
    my $mdl_rxn_hash = {};
    my $sim_rxn_translation = {};
    my $simrxnhash = {};
    for (my $i=0; $i < @{$reactionset}; $i++) {
	    my $rxn = $model->getObject("modelreactions",$reactionset->[$i]);
    		if (defined($rxn)) {
    			$mdl_rxn_hash->{$reactionset->[$i]} = $rxn;
    			my $smarts = $rxn->smarts();
    			if (defined($smarts) || length($smarts) > 0) {
    				$smartslist->{$reactionset->[$i]} = $smarts;
    			}
    		}
    } 
    my $numrxns = keys(%{$smartslist});
    if ($numrxns == 0) {
    		die "No query reactions could be found with fully defined structures";
    }
    #Print smarts list to file
    open ( my $fh, ">", $self->{'scratch'}."/SmartsList.in");
    	foreach my $Item (keys(%{$smartslist})) {
    		print $fh $Item."\t".$smartslist->{$Item}."\n";
    }
    close($fh);
    #Prepping database file
    if (!-e $self->{'scratch'}."/modelseed_reactions.json") {
    		chdir $self->{'scratch'};
    		system("tar -xzf ".$self->{python_script_dir}."/../data/modelseed_reactions.tgz");
    }   
    #Call Filipe's python script
    my $command = "python3 ".$self->{python_script_dir}."/fingerprint_matcher.py ".$self->{'scratch'}."/modelseed_reactions.json ".$self->{'scratch'}."/SmartsList.in ".$self->{'scratch'}."/ReactionList.out 0 20";
    print $command."\n";
    system($command);
    #Parse script output
    if (!-e $self->{'scratch'}."/ReactionList.out") {
    		die "Reaction list from similarity search not found!";
    }
    #reading template for rxn filter list
    open (my $fhhh, "<", $self->{python_script_dir}."/../data/Reactions.tsv");
    my $rxnhash = {};
    while (my $Line = <$fhhh>) {
        if ($Line =~ m/(rxn\d+)/) {
        		$rxnhash->{$1} = 1;
        }
    }
    close($fhhh);
    #Loading output from similarity script in json format
    $return = {similar_reactions => []};
    my $data = Bio::KBase::ObjectAPI::utilities::FROMJSON(join("\n",@{Bio::KBase::ObjectAPI::utilities::LOADFILE($self->{'scratch'}."/ReactionList.out")}));
    my $simrxn = [];
    foreach my $inrxn (keys(%{$data})) {
	    	for (my $i=0; $i < @{$data->{$inrxn}}; $i++) {
	    		my $equation = "";
	    		if (defined($ms_rxn_hash->{$data->{$inrxn}->[$i]->[1]})) {
	    			$equation = $ms_rxn_hash->{$data->{$inrxn}->[$i]->[1]}->{definition};
	    			$equation =~ s/\[0\]//g;
	    			$equation =~ s/\[1\]/[e]/g;
	    		}
	    		my $core = "no";
	    		if (defined($rxnhash->{$data->{$inrxn}->[$i]->[1]})) {
	    			$core = "yes";
	    		}
	    		push(@{$simrxn},[$inrxn,$mdl_rxn_hash->{$inrxn}->definition(),$data->{$inrxn}->[$i]->[1],$equation,$inrxn,$data->{$inrxn}->[$i]->[0],$inrxn,$data->{$inrxn}->[$i]->[0],$core]);
	    		push(@{$return->{similar_reactions}},[$data->{$inrxn}->[$i]->[1],$inrxn,$data->{$inrxn}->[$i]->[0],0]);
	    	}
    }
   	#Loading data into html template for report 
   	my $template_hash = {
		similar_rxn_data => Bio::KBase::ObjectAPI::utilities::TOJSON($simrxn)
	};	
    my $htmlreport = Bio::KBase::utilities::build_report_from_template("FindSimilarReactions",$template_hash);
	Bio::KBase::utilities::print_report_message({message => $htmlreport,append => 0,html => 1});
    $self->{fbaimpl}->util_finalize_call({
		output => $return,
		workspace => $params->{workspace},
		report_name => $reactionset->[0].".similarrxn.report",
	});
    #END find_similar_modelseed_reactions
    my @_bad_returns;
    (ref($return) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"return\" (value was \"$return\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to find_similar_modelseed_reactions:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'find_similar_modelseed_reactions');
    }
    return($return);
}




=head2 status 

  $return = $obj->status()

=over 4

=item Parameter and return types

=begin html

<pre>
$return is a string
</pre>

=end html

=begin text

$return is a string

=end text

=item Description

Return the module status. This is a structure including Semantic Versioning number, state and git info.

=back

=cut

sub status {
    my($return);
    #BEGIN_STATUS
    $return = {"state" => "OK", "message" => "", "version" => $VERSION,
               "git_url" => $GIT_URL, "git_commit_hash" => $GIT_COMMIT_HASH};
    #END_STATUS
    return($return);
}

=head1 TYPES



=head2 model_id

=over 4



=item Description

A string representing a model id.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 workspace_name

=over 4



=item Description

A string representing a workspace name.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 EachCompound

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
compound_id has a value which is a string
compound_name has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
compound_id has a value which is a string
compound_name has a value which is a string


=end text

=back



=head2 RunPickAxe

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
workspace has a value which is a kb_pickaxe.workspace_name
model_id has a value which is a kb_pickaxe.model_id
model_ref has a value which is a string
rule_set has a value which is a string
generations has a value which is an int
prune has a value which is a string
add_transport has a value which is an int
out_model_id has a value which is a kb_pickaxe.model_id
compounds has a value which is a reference to a list where each element is a kb_pickaxe.EachCompound

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
workspace has a value which is a kb_pickaxe.workspace_name
model_id has a value which is a kb_pickaxe.model_id
model_ref has a value which is a string
rule_set has a value which is a string
generations has a value which is an int
prune has a value which is a string
add_transport has a value which is an int
out_model_id has a value which is a kb_pickaxe.model_id
compounds has a value which is a reference to a list where each element is a kb_pickaxe.EachCompound


=end text

=back



=head2 PickAxeResults

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
model_ref has a value which is a string
report_name has a value which is a string
report_ref has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
model_ref has a value which is a string
report_name has a value which is a string
report_ref has a value which is a string


=end text

=back



=head2 find_similar_modelseed_reactions_params

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
workspace_name has a value which is a string
reaction_set has a value which is a reference to a list where each element is a string
structural_similarity_floor has a value which is a float
difference_similarity_floor has a value which is a float
query_model_ref has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
workspace_name has a value which is a string
reaction_set has a value which is a reference to a list where each element is a string
structural_similarity_floor has a value which is a float
difference_similarity_floor has a value which is a float
query_model_ref has a value which is a string


=end text

=back



=head2 find_similar_modelseed_reactions_results

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
similar_reactions has a value which is a reference to a list where each element is a reference to a list containing 4 items:
	0: (similar_id) a string
	1: (query_id) a string
	2: (structural_similarity) a float
	3: (reactive_similarity) a float

report_name has a value which is a string
report_ref has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
similar_reactions has a value which is a reference to a list where each element is a reference to a list containing 4 items:
	0: (similar_id) a string
	1: (query_id) a string
	2: (structural_similarity) a float
	3: (reactive_similarity) a float

report_name has a value which is a string
report_ref has a value which is a string


=end text

=back



=cut

1;
