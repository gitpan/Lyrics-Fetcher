use Test::More 'no_plan';
use_ok('Lyrics::Fetcher');

my($t) =  Lyrics::Fetcher->fetch("Pink Floyd","Echoes","AstraWeb");
ok($t , "Found Pink Floyd!");

