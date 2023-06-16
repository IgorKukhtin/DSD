-- Function: gpUpdate_Inventory_UnitComplInventFull(TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Inventory_UnitComplInventFull(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Inventory_UnitComplInventFull(
    IN inUnitId       integer,          -- ID ������
    IN inSession      TVarChar          -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

  PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CashSettings_UnitComplInvent()
                                   , Object_CashSettings.Id
                                   , inUnitId)
  FROM Object AS Object_CashSettings
  WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
  LIMIT 1;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.06.23                                                       *

*/

-- SELECT * FROM gpUpdate_Inventory_UnitComplInventFull(32335490, '3')