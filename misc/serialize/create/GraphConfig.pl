# Config file for building graphs #

use lib "/perfstat/build/1.52/server/lib";

use Graph;
use GraphMetric;
use Storable qw(lock_store lock_retrieve);

$perfhome = "/perfstat/build/1.52/server";
