package GroupPolicy;
require Storable;
@ISA = ("Storable");

sub new
{
	my $this = {};
	bless ($this, shift);
	$this->doInit(@_);
	return $this;
}

sub doInit
{
	my ($this, %arg) = @_;
	$this->{hostLimit} = $arg{hostLimit} || 50; #number of hosts allowed
	$this->{timeoutInterval} = $arg{timeoutInterval} || 80; #in minutes
	$this->{statusRefreshInterval} = $arg{statusRefreshInterval} || 5; #in minutes
}

sub getHostLimit
{
	my ($this) = @_;
	return $this->{hostLimit};
}

sub setHostLimit
{
	my ($this, $value) = @_;
	$this->{hostLimit} = $value;
}

sub getTimeoutInterval
{
	my ($this) = @_;
	return $this->{timeoutInterval};
}

sub setTimeoutInterval
{
	my ($this, $value) = @_;
	$this->{timeoutInterval} = $value;
}

sub getStatusRefreshInterval
{
	my ($this) = @_;
	return $this->{statusRefreshInterval};
}

sub setStatusRefreshInterval
{
	my ($this, $value) = @_;
	$this->{statusRefreshInterval} = $value;
}

1; #terminate the package
