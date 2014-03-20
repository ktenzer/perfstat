package HostGroup;
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
	$this->{description} = $arg{description} || "";
	$this->{owner} = $arg{owner} || die("missing owner");
	$this->{memberHash} = {};
	$this->{customGraphHash} = {};

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

sub getDescription
{
	my ($this) = @_;
	return $this->{description};
}

sub setDescription
{
	my ($this, $value) = @_;
	$this->{description} = $value;
}

sub getOwner
{
	my ($this) = @_;
	return $this->{owner};
}

sub setOwner
{
	my ($this, $value) = @_;
	$this->{owner} = $value;
}

sub getMemberHashLength
{
	my $this = shift @_;
	my $hashRef = $this->{memberHash};
	my $hashLength = keys(%$hashRef);
	return $hashLength;
}

sub addMember
{
	my ($this, $hostName) = @_;
	$this->{'memberHash'}->{$hostName} = 0;
}

sub deleteMember
{
	my ($this, $hostName) = @_;
	$arrayRef = $this->{memberArray};
	delete($this->{'memberHash'}->{$hostName});
}

sub getCustomGraphHashLength
{
	my $this = shift @_;
	my $hashRef = $this->{customGraphHash};
	my $hashLength = keys(%$hashRef);
	return $hashLength;
}

sub addGraph
{
	my ($this, $key, $obj) = @_;
	$hashRef = $this->{customGraphHash};
	$hashRef->{$key}=$obj;
}

sub deleteGraph
{
	my ($this, $key, $obj) = @_;
	$hashRef = $this->{customGraphHash};
	delete $hashref->{$key};
}

1; #terminate the package