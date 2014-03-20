package Service;
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
	$this->{serviceName} = $arg{serviceName} || die("missing service name");
	$this->{RRA} = $arg{RRA};
	$this->{rrdStep} = $arg{rrdStep};
	$this->{lastUpdate} = $arg{lastUpdate} || "0";
	$this->{notifyRule} = $arg{notifyRule};
	$this->{metricArray} = [];
	$this->{customGraphHash} = {};
}

sub getRRA
{
	my ($this) = @_;
	return $this->{RRA};
}

sub setRRA
{
	my ($this, $value) = @_;
	$this->{RRA} = $value;
}

sub getRRDStep
{
	my ($this) = @_;
	return $this->{rrdStep};
}

sub setRRDStep
{
	my ($this, $value) = @_;
	$this->{rrdStep} = $value;
}

sub getLastUpdate
{
	my ($this) = @_;
	return $this->{lastUpdate};
}

sub setLastUpdate
{
	my ($this, $value) = @_;
	$this->{lastUpdate} = $value;
}

sub getServiceName
{
	my ($this) = @_;
	return $this->{serviceName};
}

sub setServiceName
{
	my ($this, $value) = @_;
	$this->{serviceName} = $value;
}

sub getNotifyRule
{
	my ($this) = @_;
	return $this->{notifyRule};
}

sub setNotifyRule
{
	my ($this, $value) = @_;
	$this->{notifyRule} = $value;
}

sub getRRDIndexes
{
	my ($this) = @_;
	$hashPointer = {};
	$arrayLength = $this->getMetricArrayLength();
	for ($counter=0; $counter < $arrayLength; $counter++)
	{
		my $metricName = $this->{metricArray}->[$counter]->getMetricName();
		my $rrdIndex = $this->{metricArray}->[$counter]->getRRDIndex();
		$hashPointer->{$metricName} = $rrdIndex;
	}
	return $hashPointer;
}

sub addMetric
{
	my ($this, $arg) = @_;
	$arrayRef = $this->{metricArray};
	push(@$arrayRef, $arg);
}

sub deleteMetric
{
	my ($this, $skipElements) = @_;
	$arrayRef = $this->{metricArray};
	splice(@$arrayRef, skipElements);
}

sub getMetricArrayLength
{
	my $this = shift @_;
	my $arrayRef = $this->{metricArray};
	my $arrayLength = @$arrayRef;
	return $arrayLength;
}

sub getMetricArray
{
	my ($this) = @_;
	return $this->{metricArray};
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
