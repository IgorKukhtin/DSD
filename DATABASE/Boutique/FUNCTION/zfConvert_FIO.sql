DROP FUNCTION IF EXISTS zfConvert_FIO ( TVarChar, Tfloat);

CREATE OR REPLACE FUNCTION zfConvert_FIO(
     TextFIO      TVarChar,    -- ������ ������������
     ParamFIO     Tfloat
)
RETURNS  TVarChar AS
$BODY$
   DECLARE vb1 Integer;
   DECLARE vb2 Integer;
BEGIN
      IF TRIM (COALESCE (TextFIO, '')) = '' THEN  RETURN(''); END IF;

      vb1 :=  position(' ' in TextFIO);

      vb2 :=  vb1 + position(' ' in (substring( TextFIO from vb1+1 for char_length(TextFIO) ) ));

 IF (vb1 = 0 )
 THEN 
  RETURN
      substring( TextFIO from 1 for char_length(TextFIO) ) :: TVarChar ;
  END IF;

  IF (ParamFIO = 1) and (vb1 <> 0)    -- ������� �������� ����� �������
  THEN
   RETURN
      substring( TextFIO from vb1+1 for 1) || '.' || substring( TextFIO from vb2+1 for 1) || '. ' || substring( TextFIO from 1 for vb1-1) :: TVarChar ;
      
  END IF;
  IF (ParamFIO = 2) and (vb1 <> 0)    -- ������� ������� ����� �������� 
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
 -- SELECT zfConvert_FIO('�����������������������', 2)