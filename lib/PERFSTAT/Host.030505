package Host;
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
	$this->{OS} = $arg{OS} || die("missing OS");
	$this->{IP} = $arg{IP};
	$this->{Owner} = $arg{Owner};
	$this->{lastUpdate} = $arg{lastUpdate} || "0";
	$this->{cpuNum} = $arg{cpuNum} || "0";
	$this->{cpuModel} = $arg{cpuModel} || "0";
	$this->{cpuSpeed} = $arg{cpuSpeed} || "0";
	$this->{memTotal} = $arg{memTotal} || "0";
	$this->{swapTotal} = $arg{swapTotal} || "0";
	$this->{osVer} = $arg{osVer} || "0";
	$this->{kernelVer} = $arg{kernelVer} || "0";
	$this->{serviceIndex} = {};
}

sub getOS
{
	my ($this) = @_;
	return $this->{OS};
}

sub setOS
{
	my ($this, $value) = @_;
	$this->{OS} = $value;
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

sub getIP
{
	my ($this) = @_;
	return $this->{IP};
}

sub setIP
{
	my ($this, $value) = @_;
	$this->{IP} = $value;
}

sub getOwner
{
	my ($this) = @_;
	return $this->{Owner};
}

sub setOwner
{
	my ($this, $value) = @_;
	$this->{Owner} = $value;
}

sub getCpuNum
{
	my ($this) = @_;
	return $this->{cpuNum};
}

sub setCpuNum
{
	my ($this, $value) = @_;
	$this->{cpuNum} = $value;
}

sub getCpuModel
{
	my ($this) = @_;
	return $this->{cpuModel};
}

sub setCpuModel
{
	my ($this, $value) = @_;
	$this->{cpuModel} = $value;
}

sub getCpuSpeed
{
	my ($this) = @_;
	return $this->{cpuSpeed};
}

sub setCpuSpeed
{
	my ($this, $value) = @_;
	$this->{cpuSpeed} = $value;
}

sub getMemTotal
{
	my ($this) = @_;
	return $this->{memTotal};
}

sub setMemTotal
{
	my ($this, $value) = @_;
	$this->{memTotal} = $value;
}

sub getSwapTotal
{
	my ($this) = @_;
	return $this->{swapTotal};
}

sub setSwapTotal
{
	my ($this, $value) = @_;
	$this->{swapTotal} = $value;
}

sub getOsVer
{
	my ($this) = @_;
	return $this->{osVer};
}

sub setOsVer
{
	my ($this, $value) = @_;
	$this->{osVer} = $value;
}

sub getKernelVer
{
	my ($this) = @_;
	return $this->{kernelVer};
}

sub setKernelVer
{
	my ($this, $value) = @_;
	$this->{kernelVer} = $value;
}

sub getServiceIndex
{
	my ($this) = @_;
	return $this->{serviceIndex};
}

sub addService
{
	my ($this, $key, $value) = @_;
	$hashRef = $this->{serviceIndex};
	$hashRef->{$key} = $value;
}

1; #terminate the package
