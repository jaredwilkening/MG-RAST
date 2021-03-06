package resources::project;

use CGI;
use JSON;

use MGRAST::Metadata;
use WebServiceObject;

my $cgi = new CGI;
my $json = new JSON;
$json = $json->utf8();

sub about {
  my $content = { 'description' => "metagenomic project",
		  'parameters' => { "id" => "string" },
		  'return_type' => "application/json" };

  print $cgi->header(-type => 'application/json',
		     -status => 200,
		     -Access_Control_Allow_Origin => '*' );
  print $json->encode($content);
  exit 0;
}

sub request {
  my ($params) = @_;

  my $rest = $params->{rest_parameters};
  my $user = $params->{user};
  my ($master, $error) = WebServiceObject::db_connect();
  if ($rest && scalar(@$rest) == 1 && $rest->[0] eq 'about') {
    &about();
    exit 0;
  }

  if ($error) {
    print $cgi->header(-type => 'text/plain',
		       -status => 500,
		       -Access_Control_Allow_Origin => '*' );
    print "ERROR: resource database offline";
    exit 0;
  }

  my %rights = $user ? map {$_, 1} @{$user->has_right_to(undef, 'view', 'project')} : ();
  my $project;

  if ($rest && scalar(@$rest)) {
    my $id = shift @$rest;
    $id =~ s/mgp(.+)/$1/;
    $project = $master->Project->init( {id => $id} );
  } else {
    my $ids = {};
    if (exists $rights{'*'}) {
      map { $ids->{"mgp".$_->{id}} = 1 } @{ $master->Project->get_objects() };
    }
    else {
      my $public = $master->Project->get_objects( {public => 1} );
      map { $ids->{"mgp".$_->{id}} = 1 } @$public;
      map { $ids->{"mgp".$_} = 1 } keys %rights;
    }
    print $cgi->header(-type => 'application/json',
		       -status => 200,
		       -Access_Control_Allow_Origin => '*' );
    print $json->encode([sort keys %$ids]);
    exit 0;
  }
  
  if ($project && ref($project) && ($project->public || exists($rights{'*'}) || exists($rights{$project->id}))) {
    my $metadata  = $project->data();
    my @jobs      = map { "mgm".$_ } @{ $project->all_metagenome_ids };
    my @colls     = @{ $project->collections };
    my @samples   = map { "mgs".$_->{ID} } grep { $_ && ref($_) && ($_->{type} eq 'sample') } @colls;
    my @libraries = map { "mgl".$_->{ID} } grep { $_ && ref($_) && ($_->{type} eq 'library') } @colls;
    
    my $obj  = {};
    my $mddb = MGRAST::Metadata->new();
    my $desc = $metadata->{project_description} || $metadata->{study_abstract} || " - ";
    my $fund = $metadata->{project_funding} || " - ";
    if ($cgi->param('template')) {
      $metadata = $mddb->add_template_to_data('project', $metadata);
    }

    $obj->{id}             = "mgp".$project->id;
    $obj->{name}           = $project->name;
    $obj->{analyzed}       = \@jobs;
    $obj->{pi}             = $project->pi;
    $obj->{metadata}       = $metadata;
    $obj->{description}    = $desc;
    $obj->{funding_source} = $fund;
    $obj->{samples}        = \@samples;
    $obj->{libraries}      = \@libraries;
    $obj->{about}          = "metagenomics project";
    $obj->{version}        = 1;
    $obj->{url}            = $cgi->url.'/project/'.$obj->{id};
    $obj->{created}        = "";

    print $cgi->header(-type => 'application/json',
		       -status => 200,
		       -Access_Control_Allow_Origin => '*' );
    print $json->encode( $obj );
    exit 0;
  } else {
    print $cgi->header(-type => 'text/plain',
		       -status => 400,
		       -Access_Control_Allow_Origin => '*' );
    print "ERROR: project not found";
    exit 0;
  }
}

sub TO_JSON { return { %{ shift() } }; }

1;
