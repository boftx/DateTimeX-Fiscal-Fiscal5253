use Test::More;

eval "use Test::Pod::Coverage";
plan skip_all => "Test::Pod::Coverage required for testing coverage" if $@;

all_pod_coverage_ok();

done_testing();

exit;

__END__
