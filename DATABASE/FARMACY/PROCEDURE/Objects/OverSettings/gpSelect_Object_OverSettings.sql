-- Function: gpSelect_Object_OverSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_OverSettings(TVarChar);
                        
CREATE OR REPLACE FUNCTION gpSelect_Object_OverSettings(
    IN inSession     TVarChar       -- ������ ������������
) 
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitName TVarChar
             , MinPrice TFloat
             , MinimumLot TFloat
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_OverSettings());
   vbUserId:= inSession;
   --vbObjectId := lpGet_DefaultValue('zc_Object_Unit', vbUserId);

   RETURN QUERY 
        SELECT 
             Object_OverSettings.Id
           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , ObjectFloat_MinPrice.ValueData ::TFloat
           , ObjectFloat_MinimumLot.ValueData ::TFloat
           , Object_OverSettings.isErased
       FROM Object AS Object_OverSettings
            LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice 
                                  ON ObjectFloat_MinPrice.ObjectId = Object_OverSettings.Id
                                 AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_OverSettings_MinPrice()

            LEFT JOIN ObjectFloat AS ObjectFloat_MinimumLot 
                                  ON ObjectFloat_MinimumLot.ObjectId = Object_OverSettings.Id
                                  AND ObjectFloat_MinimumLot.DescId = zc_ObjectFloat_OverSettings_MinimumLot()
    
            LEFT JOIN ObjectLink AS ObjectLink_OverSettings_Unit 
                                 ON ObjectLink_OverSettings_Unit.ObjectId = Object_OverSettings.Id 
                                AND ObjectLink_OverSettings_Unit.DescId = zc_ObjectLink_OverSettings_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OverSettings_Unit.ChildObjectId 

       WHERE Object_OverSettings.DescId = zc_Object_OverSettings()
      ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.07.16         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_OverSettings ('2')
