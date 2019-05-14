unit MU110;

interface

uses System.SysUtils, System.Classes;

function MU110Init(AOwner: TComponent): boolean; stdcall;
function MU110Free: boolean; stdcall;
function MU110SetPort(APort: string): boolean; stdcall;
function MU110SetAddress(AAddress: byte): boolean; stdcall;
function MU110SetFlashTime(ATime: word): boolean; stdcall;
function MU110OutOn(AOutNumber: byte): boolean; stdcall;
function MU110OutOff(AOutNumber: byte): boolean; stdcall;
function MU110OutFlash(AOutNumber: byte): boolean; stdcall;

implementation

function MU110Init; external 'Oven.DLL' name 'MU110Init';
function MU110Free; external 'Oven.DLL' name 'MU110Free';
function MU110SetPort; external 'Oven.DLL' name 'MU110SetPort';
function MU110SetAddress; external 'Oven.DLL' name 'MU110SetAddress';
function MU110SetFlashTime; external 'Oven.DLL' name 'MU110SetFlashTime';
function MU110OutOn; external 'Oven.DLL' name 'MU110OutOn';
function MU110OutOff; external 'Oven.DLL' name 'MU110OutOff';
function MU110OutFlash; external 'Oven.DLL' name 'MU110OutFlash';

end.
