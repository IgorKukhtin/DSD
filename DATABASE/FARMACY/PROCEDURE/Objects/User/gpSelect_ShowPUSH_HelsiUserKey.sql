-- Function: gpSelect_ShowPUSH_HelsiUserKey(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_HelsiUserKey(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_HelsiUserKey(
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

   WITH tmpMedicalProgramSPUnit AS (SELECT DISTINCT ObjectLink_Unit.ChildObjectId                     AS UnitId 
                                    FROM Object AS Object_MedicalProgramSPLink
                                         INNER JOIN ObjectLink AS ObjectLink_Unit
                                                               ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                                              AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                                     WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink()
                                       AND Object_MedicalProgramSPLink.isErased = False),
        tmpUserKeyUnit AS (SELECT DISTINCT ObjectLink_User_Unit.ChildObjectId AS UnitId
                           FROM Object AS Object_User


                                 LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                                        ON ObjectLink_User_Unit.ObjectId = Object_User.Id
                                       AND ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Helsi_Unit()

                                 LEFT JOIN ObjectDate AS ObjectDate_User_KeyExpireDate
                                        ON ObjectDate_User_KeyExpireDate.DescId = zc_ObjectDate_User_KeyExpireDate() 
                                       AND ObjectDate_User_KeyExpireDate.ObjectId = Object_User.Id

                                 LEFT JOIN ObjectString AS ObjectString_KeyPassword 
                                        ON ObjectString_KeyPassword.DescId = zc_ObjectString_User_Helsi_KeyPassword() 
                                       AND ObjectString_KeyPassword.ObjectId = Object_User.Id

                                 LEFT JOIN ObjectBlob AS ObjectBlob_Key
                                        ON ObjectBlob_Key.DescId = zc_ObjectBlob_User_Helsi_Key() 
                                       AND ObjectBlob_Key.ObjectId = Object_User.Id

                           WHERE Object_User.DescId = zc_Object_User()
                             AND (ObjectDate_User_KeyExpireDate.ValueData >= CURRENT_DATE 
                              OR date_part('YEAR', ObjectDate_User_KeyExpireDate.ValueData) < 2000)
                             AND COALESCE(ObjectBlob_Key.ValueData, '') <> '' 
                             AND COALESCE(ObjectString_KeyPassword.ValueData, '') <> '')
                             
    SELECT string_agg(Object_Unit.ValueData, CHR(13))
    INTO outText
    FROM tmpMedicalProgramSPUnit
    
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMedicalProgramSPUnit.UnitId

         LEFT JOIN tmpUserKeyUnit ON tmpUserKeyUnit.UnitId = tmpMedicalProgramSPUnit.UnitId
         
    WHERE COALESCE (tmpUserKeyUnit.UnitId, 0) = 0
      AND Object_Unit.ValueData NOT ILIKE '%��������%'
      AND Object_Unit.ValueData NOT ILIKE '%�������%' 
      AND Object_Unit.isErased = False
    ;      

    IF COALESCE(outText, '') <> ''
    THEN
      outShowMessage := True;
      outPUSHType := 3;
      outText := '������������� �� ������� ��� ��������� ��������� �����:'||CHR(13)||CHR(13)||outText;
     END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.03.22                                                       *

*/

-- 
select * from gpSelect_ShowPUSH_HelsiUserKey(inSession := '3');