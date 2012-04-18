use strict;
use warnings;
no warnings qw(redefine);

1;

# this class is AUTOGENERATED and will be AUTOMATICALLY REGENERATED
# all work done in this module will be LOST


package MGRASTMetadata::Log;

use DBObject;
use base qw(DBObject);

sub attributes {
     return {
		entry => [ DB_SCALAR, undef, 0, undef ],
		time => [ DB_SCALAR, undef, 0, undef ],
		type => [ DB_SCALAR, undef, 0, undef ],
		job => [ DB_OBJECT, "MG_jobcache::Job", 0, undef ],
	};
}

sub unique_indices {
     return 
		[
		];
}

sub indices {
     return 
		[
			[ "job" ],
		];
}

1;

package MGRASTMetadata::JobMD;

use DBObject;
use base qw(DBObject);

sub attributes {
     return {
		value => [ DB_SCALAR, undef, 1, undef ],
		tag => [ DB_SCALAR, undef, 1, undef ],
		job => [ DB_OBJECT, "MG_jobcache::Job", 0, undef ],
	};
}

sub unique_indices {
     return 
		[
		];
}

sub indices {
     return 
		[
			[ "job" ],
			[ "tag" ],
		];
}

1;

package MGRASTMetadata::ProjectMD;

use DBObject;
use base qw(DBObject);

sub attributes {
     return {
		project => [ DB_OBJECT, "MG_jobcache::Project", 0, undef ],
		value => [ DB_SCALAR, undef, 1, undef ],
		tag => [ DB_SCALAR, undef, 1, undef ],
	};
}

sub unique_indices {
     return 
		[
		];
}

sub indices {
     return 
		[
			[ "project" ],
		];
}

1;