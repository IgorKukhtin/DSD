-- Function: zfConvert_FIO_Name ()

DROP FUNCTION IF EXISTS zfConvert_FIO_Name (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_FIO_Name(
     TextFIO      TVarChar
)
RETURNS  TVarChar
AS
$BODY$
   DECLARE vb1 Integer;
   DECLARE vb2 Integer;
BEGIN
      IF TRIM (COALESCE (TextFIO, '')) = '' THEN  RETURN(''); END IF;

      vb1 :=  position(' ' in TextFIO);

      vb2 :=  position(' ' in (substring( TextFIO from vb1+1 for char_length(TextFIO) ) ) ) ;

 IF (vb1 = 0 )
 THEN 
  RETURN
      substring( TextFIO from 1 for char_length(TextFIO) ) :: TVarChar ;
  END IF;

  IF (vb2 = 0)     -- ��� ��������
  THEN
      RETURN
            (substring (TextFIO from vb1+1 for char_length(TextFIO))) :: TVarChar;
  END IF;

  IF (vb1 <> 0) and (vb2 <> 0)    -- 
  THEN
       RETURN
            (substring (TextFIO from vb1+1 for vb2-1)) :: TVarChar;
  END IF;
  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.11.17         *
*/

-- ����
-- SELECT zfConvert_FIO_Name('������� ���� ������������') 