DROP FUNCTION IF EXISTS zfConvert_FIO ( TVarChar, Tfloat);

CREATE OR REPLACE FUNCTION zfConvert_FIO(
     TextFIO      TVarChar,    -- ������ ������������
     ParamFIO        Tfloat
)
RETURNS  TVarChar AS
$BODY$
   DECLARE vb1 Integer;
   DECLARE vb2 Integer;
BEGIN
     
      vb1 :=  position(' ' in TextFIO);
      vb2 :=  vb1 + position(' ' in (substring( TextFIO from vb1+1 for char_length(TextFIO) ) ));

 
  IF ParamFIO = 1    -- ������� �������� ����� �������
  THEN
   RETURN
      substring( TextFIO from vb1+1 for 1) || '.' || substring( TextFIO from vb2+1 for 1) || '. ' || substring( TextFIO from 1 for vb1-1) :: TVarChar ;
      
  END IF;
  IF ParamFIO = 2    -- ������� ������� ����� �������� 
  THEN
   RETURN
      substring( TextFIO from 1 for vb1-1)|| ' ' || substring( TextFIO from vb1+1 for 1) || '.' || substring( TextFIO from vb2+1 for 1) || '. '   :: TVarChar ;
  END IF;
  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.11.15         *
*/
-- ����
--     SELECT zfConvert_FIO('������� ���� ������������')