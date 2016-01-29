-- Function: gpGetTaraMovementDescSets()

DROP FUNCTION IF EXISTS gpGetTaraMovementDescSets(TVarChar);

CREATE OR REPLACE FUNCTION gpGetTaraMovementDescSets(
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (
    InDesc           TVarChar, --����� ���������� ��������
    InBayDesc        TVarChar, --����� ������� ��������
    OutDesc          TVarChar, --����� ���������� ��������
    OutSaleDesc      TVarChar, --����� ������� ��������
    InventoryDesc    TVarChar, --����� ��������������
    LossDesc         TVarChar, --����� ��������
    InMLODesc        Integer,  --���� "�� ���� / ����" ��� ��������
    OutMLODesc       Integer,  --���� "�� ���� / ����" ��� ��������
    InventoryMLODesc Integer,  --���� "�� ���� / ����" ��� ��������������
    LossMLODesc      Integer)  --���� "�� ���� / ����" ��� ��������
AS
$BODY$
BEGIN

    RETURN QUERY
        SELECT
            ((Select STRING_AGG(Id::TVarChar,';') from MovementDesc Where Id not in (zc_Movement_Inventory(), zc_Movement_Loss()))||';IN;InternalMovement')::TVarChar    AS InDesc
          , ((Select STRING_AGG(Id::TVarChar,';') from MovementDesc Where Id not in (zc_Movement_Inventory(), zc_Movement_Loss()))||';IN;ExternalMovement')::TVarChar    AS InBayDesc
          , ((Select STRING_AGG(Id::TVarChar,';') from MovementDesc Where Id not in (zc_Movement_Inventory(), zc_Movement_Loss()))||';OUT;InternalMovement')::TVarChar   AS OutDesc
          , ((Select STRING_AGG(Id::TVarChar,';') from MovementDesc Where Id not in (zc_Movement_Inventory(), zc_Movement_Loss()))||';OUT;ExternalMovement')::TVarChar   AS outSaleDesc
          , zc_Movement_Inventory()::TVarChar AS InventoryDesc
          , zc_Movement_Loss()::TVarChar      AS LossDesc
          , zc_MovementLinkObject_From()      AS InMLODesc
          , zc_MovementLinkObject_To()        AS OutMLODesc
          , zc_MovementLinkObject_To()        AS InventoryMLODesc
          , zc_MovementLinkObject_To()        AS LossMLODesc
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGetTaraMovementDescSets (TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 18.12.15                                                        *

*/

-- ����
-- SELECT * FROM gpGetTaraMovementDescSets (inSession:= '2')