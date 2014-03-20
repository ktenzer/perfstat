package GraphMetric;

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
	$this->{color} = $arg{color} || die("missing color");
	$this->{lineType} = $arg{lineType} || die("missing line type");
	$this->{gprintArray} = $arg{gprintArray} || [];
	$this->{cDefinition} = $arg{cDefinition};
	$this->{subGraphExclude} = $arg{subGraphExclude};
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

sub addGprint
{
        my ($this, $arg) = @_;
        $arrayRef = $this->{gprintArray};
        push(@$arrayRef, $arg);
}

sub deleteGprint
{
        my ($this, $skipElements) = @_;
        $arrayRef = $this->{gprintArray};
        splice(@$arrayRef, skipElements);
}

sub updateGprint
{

}

sub getGprintArrayLength
{
        my $this = shift @_;
        my $arrayRef = $this->{gprintArray};
        my $arrayLength = @$arrayRef;
        return $arrayLength;
}

sub getCdefinition
{
        my ($this) = @_;
        return $this->{cDefinition};
}

sub setCdefintion
{
        my ($this, $value) = @_;
        $this->{cDefinition} = $value;
}

sub getColor
{
        my ($this) = @_;
        return $this->{color};
}

sub setColor
{
        my ($this, $value) = @_;
        $this->{color} = $value;
}

sub getLineType
{
        my ($this) = @_;
        return $this->{lineType};
}

sub setLineType
{
        my ($this, $value) = @_;
        $this->{lineType} = $value;
}

sub getSubGraphExclude
{
        my ($this) = @_;
        return $this->{subGraphExclude};
}

sub setSubGraphExclude
{
        my ($this, $value) = @_;
        $this->{subGraphExclude} = $value;
}

1; #terminate the package
