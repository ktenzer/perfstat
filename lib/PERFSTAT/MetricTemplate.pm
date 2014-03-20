package MetricTemplate;
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
	$this->{name} = $arg{name};
	$this->{description} = $arg{description};
  $this->{ruleSetIndex} = {};
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

sub getRuleSetIndex
{
	my ($this) = @_;
	return $this->{ruleSetIndex};
}

1; #terminate the package
