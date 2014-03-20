package Graph;

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
	$this->{title} = $arg{title} || "";
	$this->{comment} = $arg{comment} || "";
	$this->{imageFormat} = $arg{imageFormat} || "";
	$this->{rrdWidth} = $arg{rrdWidth} || "";
	$this->{rrdHeight} = $arg{rrdHeight} || "";
	$this->{verticalLabel} = $arg{verticalLabel} || "";
	$this->{upperLimit} = $arg{upperLimit};
	$this->{lowerLimit} = $arg{lowerLimit};
	$this->{rigid} = $arg{rigid} || "";
	$this->{base} = $arg{base} || "";
	$this->{unitsExponent} = $arg{unitsExponent};
	$this->{noMinorGrids} = $arg{noMinorGrids} || "";
	$this->{stepValue} = $arg{stepValue} || "";
	$this->{gprintFormat} = $arg{gprintFormat} || "";
	$this->{pieWidth} = $arg{pieWidth} || "";
	$this->{pieHeight} = $arg{pieHeight} || "";
	$this->{pie3d} = $arg{pie3d} || "";
	$this->{barWidth} = $arg{barWidth} || "";
	$this->{barHeight} = $arg{barHeight} || "";
	$this->{barSpacing} = $arg{barSpacing} || "";
	$this->{metricIndexHash} = {};
	$this->{metricArray} = [];
	$this->{colorsArray} = $arg{colorsArray} || [];
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

sub getTitle
{
	my ($this) = @_;
	return $this->{title};
}

sub setTitle
{
	my ($this, $value) = @_;
	$this->{title} = $value;
}

sub getComment
{
        my ($this) = @_;
        return $this->{comment};
}

sub setComment
{
        my ($this, $value) = @_;
        $this->{comment} = $value;
}

sub getImageFormat
{
        my ($this) = @_;
        return $this->{imageFormat};
}

sub setImageFormat
{
        my ($this, $value) = @_;
        $this->{imageFormat} = $value;
}

sub getRRDWidth
{
        my ($this) = @_;
        return $this->{rrdWidth};
}

sub setRRDWidth
{
        my ($this, $value) = @_;
        $this->{rrdWidth} = $value;
}

sub getRRDHeight
{
        my ($this) = @_;
        return $this->{rrdHeight};
}

sub setRRDHeight
{
        my ($this, $value) = @_;
        $this->{rrdHeight} = $value;
}

sub getVerticalLabel
{
        my ($this) = @_;
        return $this->{verticalLabel};
}

sub setVerticalLabel
{
        my ($this, $value) = @_;
        $this->{verticalLabel} = $value;
}

sub getUpperLimit
{
        my ($this) = @_;
        return $this->{upperLimit};
}

sub setUpperLimit
{
        my ($this, $value) = @_;
        $this->{upperLimit} = $value;
}

sub getLowerLimit
{
        my ($this) = @_;
        return $this->{lowerLimit};
}

sub setLowerLimit
{
        my ($this, $value) = @_;
        $this->{lowerLimit} = $value;
}

sub getRigid
{
        my ($this) = @_;
        return $this->{rigid};
}

sub setRigid
{
        my ($this, $value) = @_;
        $this->{rigid} = $value;
}

sub getBase
{
        my ($this) = @_;
        return $this->{base};
}

sub setBase
{
        my ($this, $value) = @_;
        $this->{base} = $value;
}

sub getUnitsExponent
{
        my ($this) = @_;
        return $this->{unitsExponent};
}

sub setUnitsExponent
{
        my ($this, $value) = @_;
        $this->{unitsExponent} = $value;
}

sub getNoMinorGrids
{
        my ($this) = @_;
        return $this->{noMinorGrids};
}

sub setNoMinorGrids
{
        my ($this, $value) = @_;
        $this->{noMinoreGrids} = $value;
}

sub getStepValue
{
        my ($this) = @_;
        return $this->{stepValue};
}

sub setStepValue
{
        my ($this, $value) = @_;
        $this->{stepValue} = $value;
}

sub getGprintFormat
{
        my ($this) = @_;
        return $this->{gprintFormat};
}

sub setGprintFormat
{
        my ($this, $value) = @_;
        $this->{gprintFormat} = $value;
}

sub getPieWidth
{
        my ($this) = @_;
        return $this->{pieWidth};
}

sub setPieWidth
{
        my ($this, $value) = @_;
        $this->{pieWidth} = $value;
}

sub getPieHeight
{
        my ($this) = @_;
        return $this->{pieHeight};
}

sub setPieHeight
{
        my ($this, $value) = @_;
        $this->{pieHeight} = $value;
}

sub getPie3d
{
        my ($this) = @_;
        return $this->{pie3d};
}

sub setPie3d
{
        my ($this, $value) = @_;
        $this->{pie3d} = $value;
}

sub getBarWidth
{
        my ($this) = @_;
        return $this->{barWidth};
}

sub setBarWidth
{
        my ($this, $value) = @_;
        $this->{barWidth} = $value;
}

sub getBarHeight
{
        my ($this) = @_;
        return $this->{barHeight};
}

sub setBarHeight
{
        my ($this, $value) = @_;
        $this->{barHeight} = $value;
}

sub getBarSpacing
{
        my ($this) = @_;
        return $this->{barSpacing};
}

sub setBarSpacing
{
        my ($this, $value) = @_;
        $this->{barSpacing} = $value;
}

sub addGraphMetric
{
	my ($this, $key, $obj) = @_;
	my $arrayRef = $this->{metricArray};
	push(@$arrayRef, $obj);
	my $dataRef = \@$arrayRef;
	my $length = $#$dataRef;
	my $hashRef = $this->{metricIndexHash};
	$hashRef->{$key} = $length;
}

sub addColor
{
        my ($this, $arg) = @_;
        $arrayRef = $this->{colorsArray};
        push(@$arrayRef, $arg);
}

sub deleteColor
{
        my ($this, $skipElements) = @_;
        $arrayRef = $this->{colorsArray};
        splice(@$arrayRef, skipElements);
}

sub updateColor
{

}

sub getColorsArrayLength
{
        my $this = shift @_;
        my $arrayRef = $this->{colorsArray};
        my $arrayLength = @$arrayRef;
        return $arrayLength;
}

1;
