-- Function: gpUpdate_Inventory_CompileUnitFull(TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Inventory_CompileUnitFull(integer, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Inventory_CompileUnitFull(
    IN inMovementID   integer,          -- ID ��������������
    IN inUnitId       integer,          -- ID ������
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
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CashSettings_UnitComplInvent()
                                     , Object_CashSettings.Id
                                     , inUnitId)
    FROM Object AS Object_CashSettings
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;
  END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.06.23                                                       *

*/

-- SELECT * FROM gpUpdate_Inventory_CompileUnitFull(32335490, 0, '3')