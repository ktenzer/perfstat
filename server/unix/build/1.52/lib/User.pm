package User;
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
	$this->{name} = $arg{name} || die("missing name");
	$this->{password} = $arg{password} || die("missing password");
	$this->{creator} = $arg{creator} || die("missing creator");
	$this->{role} = $arg{role} || die("missing role");
	$this->{navBarWidth} = $arg{navBarWidth} || 180; #in pixels
	$this->{showAllHosts} = $arg{showAllHosts} || 1; #boolean
}

sub getName
{
	my ($this) = @_;
	return $this->{name};
}

sub setName
{
	my ($this, $value) = @_;
	$this->{name} = $value;
}

sub getPassword
{
	my ($this) = @_;
	return $this->{password};
}

sub setPassword
{
	my ($this, $value) = @_;
	$this->{password} = $value;
}

sub getCreator
{
	my ($this) = @_;
	return $this->{creator};
}

sub setCreator
{
	my ($this, $value) = @_;
	$this->{creator} = $value;
}

sub getRole
{
	my ($this) = @_;
	return $this->{role};
}

sub setRole
{
	my ($this, $value) = @_;
	$this->{role} = $value;
}

sub getNavBarWidth
{
	my ($this) = @_;
	return $this->{navBarWidth};
}

sub setNavBarWidth
{
	my ($this, $value) = @_;
	$this->{navBarWidth} = $value;
}

sub getShowAllHosts
{
	my ($this) = @_;
	return $this->{showAllHosts};
}

sub setShowAllHosts
{
	my ($this, $value) = @_;
	$this->{showAllHosts} = $value;
}

1; #terminate the package