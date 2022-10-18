-- Function: zfConvert_CheckStringToFloat

-- DROP FUNCTION IF EXISTS zfConvert_CheckStringToFloat (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_CheckStringToFloat(Number TVarChar)
RETURNS TFloat AS
$BODY$
   DECLARE vbNumber TVarChar;
   DECLARE vbChar TVarChar;
   DECLARE vbPos integer;
BEGIN

  Number := REPLACE(Number, ',', '.');
  vbNumber := '';
  vbPos := 1;
  vbChar := SUBSTRING (Number, vbPos, 1);
  WHILE vbChar <> ''
  LOOP
    
    IF '+-0123456789.' ILIKE '%'||vbChar||'%'
    THEN
      vbNumber := vbNumber||vbChar;
    ELSEIF vbNumber <> ''
    THEN
      EXIT;
    END IF;
    
    vbPos := vbPos + 1;          
    vbChar := SUBSTRING (Number, vbPos, 1);
  END LOOP;  
        
  BEGIN
    RETURN vbNumber :: TFloat;
  EXCEPTION
    WHEN OTHERS THEN	
       RETURN 0;
  END;
  
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.10.22                                                       *  
*/

-- ����
SELECT * FROM zfConvert_CheckStringToFloat ('-0,1321446')