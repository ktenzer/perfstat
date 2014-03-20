package Report;
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
  $this->{numColumns} = $arg{numColumns} || "1";
  $this->{graphSize} = $arg{graphSize} || "medium";
  $this->{customGraphSize} = $arg{customGraphSize} || "";
  $this->{customFontSize} = $arg{customFontSize} || "";
  $this->{useShortDomainNames} = $arg{useShortDomainNames} || "0";
	$this->{contentArray} = [];
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

sub getNumColumns
{
	my ($this) = @_;
	return $this->{numColumns};
}
sub setNumColumns
{
	my ($this, $value) = @_;
	$this->{numColumns} = $value;
}

sub getGraphSize
{
	my ($this) = @_;
	return $this->{graphSize};
}
sub setGraphSize
{
	my ($this, $value) = @_;
	$this->{graphSize} = $value;
}

sub getCustomGraphSize
{
	my ($this) = @_;
	return $this->{customGraphSize};
}
sub setCustomGraphSize
{
	my ($this, $value) = @_;
	$this->{customGraphSize} = $value;
}

sub getCustomFontSize
{
	my ($this) = @_;
	return $this->{customFontSize};
}
sub setCustomFontSize
{
	my ($this, $value) = @_;
	$this->{customFontSize} = $value;
}

sub getUseShortDomainNames
{
	my ($this) = @_;
	return $this->{useShortDomainNames};
}
sub setUseShortDomainNames
{
	my ($this, $value) = @_;
	$this->{useShortDomainNames} = $value;
}

sub getContentArrayLength
{
	my $this = shift @_;
	my $arrayRef = $this->{contentArray};
	my $arrayLength = @$arrayRef;
	return $arrayLength;
}

sub getContentArray
{
	my $this = shift @_;
	my $arrayRef = $this->{'contentArray'};
	return $arrayRef;
}

sub addContent
{
  my ($this, $content) = @_;
  my $arrayRef = $this->{'contentArray'};
  push(@$arrayRef, $content);
}

sub updateContent
{
  my ($this, $content, $contentID) = @_;
  my $arrayRef = $this->{'contentArray'};
  $arrayRef->[$contentID] = $content;
}

sub deleteAllContent
{
  my ($this) = @_;
  $arrayRef = $this->{'contentArray'};
  splice(@$arrayRef, 0);
}

sub deleteContent
{
  my ($this, $skipElements) = @_;
  $arrayRef = $this->{'contentArray'};
  splice(@$arrayRef, $skipElements, 1);
}

1; #terminate the package
