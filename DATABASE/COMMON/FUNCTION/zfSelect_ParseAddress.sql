-- Function: zfConvert_ParseAddress

DROP FUNCTION IF EXISTS zfSelect_ParseAddress (TVarChar);


CREATE OR REPLACE FUNCTION zfSelect_ParseAddress(
    IN inAddress    TVarChar
)
RETURNS TABLE (PostcodeCode TVarChar, CityName TVarChar, StreetName TVarChar, CountrySubDivisionName TVarChar
              )
AS
$BODY$
   DECLARE vbIndex Integer;

   DECLARE vbPostcodeCode TVarChar;
   DECLARE vbCityName TVarChar;
   DECLARE vbStreetName TVarChar;
   DECLARE vbCountrySubDivisionName TVarChar;
   
   DECLARE vbStart Integer;
   DECLARE vbCity Integer;
   DECLARE vbStreet Integer;
   DECLARE text_var1 Text;   
   DECLARE vbShortName TVarChar;
BEGIN
   
    vbPostcodeCode := '';
    vbCityName := '';
    vbStreetName := '';
    vbCountrySubDivisionName := '';

    vbCity := 0;
    vbStreet := 0;

    IF SPLIT_PART (inAddress, ',', 1) ILIKE '%���%'
    THEN
      vbStart := 2;
    ELSE
      vbStart := 1;
    END IF;
    
    BEGIN
      vbPostcodeCode := ((Trim(SPLIT_PART(inAddress, ',', vbStart)))::Integer)::TVarChar;
      vbStart := vbStart + 1;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
    END;

    -- ������ 
    vbIndex := vbStart;
    WHILE SPLIT_PART (inAddress, ',', vbIndex) <> '' 
    LOOP
    
       IF vbCity = 0 AND ( 
          Trim(SPLIT_PART (inAddress, ',', vbIndex)) ILIKE '�.%' OR
          Trim(SPLIT_PART (inAddress, ',', vbIndex)) ILIKE '� %' OR
          Trim(SPLIT_PART (inAddress, ',', vbIndex)) ILIKE '�.�.%' OR
          Trim(SPLIT_PART (inAddress, ',', vbIndex)) ILIKE '�.%' OR
          Trim(SPLIT_PART (inAddress, ',', vbIndex)) ILIKE '� %' OR
          Trim(SPLIT_PART (inAddress, ',', vbIndex)) ILIKE '���%')
       THEN
          vbCity = vbIndex;
       END IF;
       
       IF vbStreet = 0 AND vbCity > 0 AND vbCity < vbIndex
       THEN
          FOR vbShortName IN
            SELECT DISTINCT StreetKind.ShortName
            FROM gpSelect_Object_StreetKind( inSession := '') AS StreetKind WHERE COALESCE(StreetKind.ShortName, '') <> '' 
          LOOP

             IF Trim(SPLIT_PART (inAddress, ',', vbIndex)) ILIKE vbShortName||'%'
             THEN
                vbStreet = vbIndex;
             END IF;

          END LOOP;
       END IF;
        
       -- ������ ����������
       vbIndex := vbIndex + 1;
    END LOOP;
  
    -- ���������
    vbIndex := vbStart;
    WHILE SPLIT_PART (inAddress, ',', vbIndex) <> '' 
    LOOP
    
       IF vbIndex < vbCity
       THEN 
         IF COALESCE (vbCountrySubDivisionName, '') <> '' THEN vbCountrySubDivisionName := vbCountrySubDivisionName || ', '; END IF;
         vbCountrySubDivisionName := vbCountrySubDivisionName || Trim(SPLIT_PART (inAddress, ',', vbIndex));
       ELSEIF  vbIndex < vbStreet
       THEN
         IF COALESCE (vbStreetName, '') <> '' THEN vbStreetName := vbStreetName || ', '; END IF;
         vbStreetName := vbStreetName || Trim(SPLIT_PART (inAddress, ',', vbIndex));
       ELSE
         IF COALESCE (vbCityName, '') <> '' THEN vbCityName := vbCityName || ', '; END IF;
         vbCityName := vbCityName || Trim(SPLIT_PART (inAddress, ',', vbIndex));
       END IF;
        
       -- ������ ����������
       vbIndex := vbIndex + 1;
    END LOOP;
    
    -- ���������
    RETURN QUERY
      SELECT vbPostcodeCode, vbCityName, vbStreetName, vbCountrySubDivisionName;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.05.23                                                       *
*/

-- ����
-- 

SELECT * FROM zfSelect_ParseAddress (inAddress := '������, 49000,��i������������� ���.,�.��i���,�������� �-�,���.��������,26');
