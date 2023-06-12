-- Function: gpSelect_ShowCompilePUSH_InventoryFull(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowCompilePUSH_InventoryFull(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowCompilePUSH_InventoryFull(
    IN inMovementID   integer,          -- ID ��������������
   OUT outShowMessage Boolean,          -- ��������� ���������
   OUT outPUSHType    Integer,          -- ��� ���������
   OUT outText        Text,             -- ����� ���������
    IN inSession      TVarChar          -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN

  outShowMessage := False;

  IF EXISTS(SELECT 1 
            FROM MovementBoolean AS MovementBoolean_FullInvent
            WHERE MovementBoolean_FullInvent.MovementId = inMovementID
              AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
              AND MovementBoolean_FullInvent.ValueData = True)
  THEN
    outShowMessage := True;
    outPUSHType := zc_TypePUSH_Information();
    outText := '���������� �������� �� �������� ����� ����� ������ ����� ���������� ������ ��������������.';
  END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.06.23                                                       *

*/

-- SELECT * FROM gpSelect_ShowCompilePUSH_InventoryFull(32335490  , '3')