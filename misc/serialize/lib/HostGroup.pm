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
	$this->{memberArray} = [];

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

sub getMemberArrayLength
{
	my $this = shift @_;
	my $arrayRef = $this->{memberArray};
	my $arrayLength = @$arrayRef;
	return $arrayLength;
}

sub addMember
{
	my ($this, $arg) = @_;
	$arrayRef = $this->{memberArray};
	push(@$arrayRef, $arg);
}

sub deleteMember
{
	my ($this, $skipElements) = @_;
	$arrayRef = $this->{memberArray};
	splice(@$arrayRef, $skipElements, 1);
}

1; #terminate the package