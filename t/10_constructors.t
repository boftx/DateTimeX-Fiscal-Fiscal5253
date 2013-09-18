use strict;
use warnings;

use DateTime;

use Test::More;

require DateTimeX::Fiscal::Fiscal5253;
my $class = 'DateTimeX::Fiscal::Fiscal5253';

# This script tests the constructor method. Each parameter is tested with
# both valid and invalid values as well. Other scripts will test the
# actual object returned by a given constructor. The idea is that if
# a constructor fails to perform as expected there is no need for
# further testing.

# Get a DT object for testing the 'date' parameter.
my $dt = DateTime->now();

# and make a bad one, too
my $bad_dt = bless {}, 'BadDateTime';

# Preparing an array of test cases makes it slightly easier, IMHO, to
# see what cases are being covered.
my @goodparams = (
    {
        tname => 'Basic constuctor',
        params => {
        },
    },
    {
        tname => 'minimum end_month value',
        params => {
            end_month => '1',
        },
    },
    {
        tname => 'maximum end_month value',
        params => {
            end_month => '1',
        },
    },
    {
        tname => 'minimum end_dow value',
        params => {
            end_month => '1',
        },
    },
    {
        tname => 'maximum end_dow value',
        params => {
            end_month => '7',
        },
    },
    {
        tname => 'end_type = "last"',
        params => {
            end_type => 'last',
        },
    },
    {
        tname => 'end_type = "closest"',
        params => {
            end_type => 'closest',
        },
    },
    {
        tname => 'leap_period = "first"',
        params => {
            leap_period => 'first',
        },
    },
    {
        tname => 'leap_period = "last"',
        params => {
            leap_period => 'last',
        },
    },
    {   # test that end_type is case-insensitive, undocumented
        tname => 'end_type = "LaSt"',
        params => {
            end_type => 'LaSt',
        },
    },
    {   # test that end_type is case-insensitive, undocumented
        tname => 'end_type = "ClOsEsT"',
        params => {
            end_type => 'ClOsEsT',
        },
    },
    {
        tname => 'good year parameter',
        params => {
            year => 2012,
        },
    },
    {
        tname => 'Valid DT object in date parameter',
        params => {
            date => $dt,
        },
    },
    {
        tname => 'good date parameter, format mm/dd/yyyy',
        params => {
            date => '01/01/2012',
        },
    },
    {
        tname => 'good date parameter with single digit days/months',
        params => {
            date => '1/1/2012',
        },
    },
    {
        tname => 'good date parameter, format yyyy-mm-dd',
        params => {
            date => '2012-01-01',
        },
    },
    {
        tname => 'good date parameter with single digit days/months',
        params => {
            date => '2012-1-1',
        },
    },
    {
        tname => 'good date parameter, format yyyy-mm-ddThh:mm:ss',
        params => {
            date => '2012-01-01T00:00:00',
        },
    },
    {
        tname => 'good date parameter, format yyyy-mm-dd hh:mm:ss',
        params => {
            date => '2012-01-01 00:00:00',
        },
    },
);

# All of these constructor calls should fail with a return value of undef.
my @failparams = (
    {
        tname => 'detect unknown parameter',
        params => {
            foo => 'bar',
        },
        match => 'Unknown param',
    },
    {
        tname => 'detect invalid value for param end_month: 0',
        params => {
            end_month => 0,
        },
        match => 'Invalid value for param end_month',
    },
    {
        tname => 'detect invalid value for param end_month: 13',
        params => {
            end_month => 13,
        },
        match => 'Invalid value for param end_month',
    },
    {
        tname => 'detect invalid value for param end_dow: 0',
        params => {
            end_dow => 0,
        },
        match => 'Invalid value for param end_dow',
    },
    {
        tname => 'detect invalid value for param end_dow: 8',
        params => {
            end_dow => 8,
        },
        match => 'Invalid value for param end_dow',
    },
    {
        tname => 'detect unknown value for param end_type',
        params => {
            end_type => 'foobar',
        },
        match => 'Invalid value for param end_type',
    },
    {
        tname => 'detect unknown value for leap_period',
        params => {
            leap_period => 'foobar',
        },
        match => 'Invalid value for param leap_period',
    },
    {
        tname => 'detect mutually exclusive year and date parameters',
        params => {
            year => 2012,
            date => $dt,
        },
        match => 'Mutually exclusive',
    },
    {
        tname => 'detect invalid object/reference in date parameter',
        params => {
            date => $bad_dt,
        },
        match => 'Object',
    },
    {
        tname => 'detect unparsable date, too many digits in month',
        params => {
            date => '110/01/2012',
        },
        match => 'Unable to parse',
    },
    {
        tname => 'detect unparsable date, too many digits in day',
        params => {
            date => '00/110/2012',
        },
        match => 'Unable to parse',
    },
    {
        tname => 'detect unparsable year in date parameter',
        params => {
            date => '01/01/12',
        },
        match => 'Unable to parse',
    },
    {
        tname => 'detect DateTime error',
        params => {
            date => '01/32/2012',
        },
        match => 'Invalid date',
    },
    {
        tname => 'detect unparsable date, too many digits in month',
        params => {
            date => '2012-110-01',
        },
        match => 'Unable to parse',
    },
    {
        tname => 'detect unparsable date, too many digits in day',
        params => {
            date => '2012-01-110',
        },
        match => 'Unable to parse',
    },
    {
        tname => 'detect unparsable year in date parameter',
        params => {
            date => '12-01-01',
        },
        match => 'Unable to parse',
    },
    {
        tname => 'detect DateTime error',
        params => {
            date => '2012-01-32',
        },
        match => 'Invalid date',
    },
);

my $testplan = @goodparams + (@failparams * 2);
$testplan *= 2;

plan( tests => $testplan );

# Loop through the good combinations
# Yes, this could use "new_ok", but I don't like representing a hash as an
# array, even though that is technically what it is internally.
# "Fat commas" are ugly.
foreach ( @goodparams ) {
    my $fc = $class->new(%{$_->{params}});
    isa_ok($fc,$class,$_->{tname});
}

# Now test the bad param combinations
# Disable STDERR so we don't get a lot of clutter from intentional failures.
foreach ( @failparams ) {
    my $fc = eval { $class->new(%{$_->{params}}) };
    is($fc,undef,$_->{tname});
    like($@,qr/$_->{match}/,$_->{tname});
}

# Now do it all over again using the Empty::Fiscal5253 class to be sure
# this module can be safely sub-classed. A single test of the basic
# constructor would probably suffice, but why not be sure?

$class = 'Empty::Fiscal5253';

# Loop through the good combinations
foreach ( @goodparams ) {
    my $fc = $class->new(%{$_->{params}});
    isa_ok($fc,$class,$_->{tname});
}

# Now test the bad param combinations
# Capture STDERR to check for correct error message.
foreach ( @failparams ) {
    my $fc = eval { $class->new(%{$_->{params}}) };
    is($fc,undef,$_->{tname});
    like($@,qr/$_->{match}/,$_->{tname});
}

exit;

# package for empty package tests
package Empty::Fiscal5253;
use base qw(DateTimeX::Fiscal::Fiscal5253);

__END__
