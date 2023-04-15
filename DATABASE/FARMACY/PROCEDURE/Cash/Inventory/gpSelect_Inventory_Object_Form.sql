-- Function: gpSelect_Inventory_Object_Form()

DROP FUNCTION IF EXISTS gpSelect_Inventory_Object_Form (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Inventory_Object_Form(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (FormName TVarChar
             , FormData TBlob
             , FormSettings TBlob
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ListDiff());
   vbUserId:= lpGetUserBySession (inSession);
    
   RETURN QUERY
   SELECT Object.ValueData                AS FormName
        , ObjectBLOB_FormData.ValueData   AS FormData
        , gpGet_Object_UserFormSettings(Object.ValueData ,  inSession)::TBlob  AS FormSettings
   FROM Object
        INNER JOIN ObjectBLOB AS ObjectBLOB_FormData 
                              ON ObjectBLOB_FormData.ObjectId = Object.Id
                             AND ObjectBLOB_FormData.DescId   = zc_ObjectBlob_Form_Data() 
   WHERE Object.ValueData IN ('TUnitLocalForm', 'TDataDialogForm')
     AND Object.DescId = zc_Object_Form()
    ;
    

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 13.04.23                                                      *
*/

-- ����
-- 

select * from gpSelect_Inventory_Object_Form( inSession := '3');    