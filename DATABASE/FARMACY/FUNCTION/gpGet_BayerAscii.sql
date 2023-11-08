-- Function: gpGet_BayerAscii()

DROP FUNCTION IF EXISTS gpGet_BayerAscii(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_BayerAscii(
    IN inBayer             TVarChar  -- ���������� ��� 
)
RETURNS TVarChar
AS
$BODY$
BEGIN
  inBayer := Trim(translate(inBayer, chr('8296')||chr('8297')||chr('8203'), ''));    
  inBayer := Trim(translate(inBayer, chr('180')||chr('769')||chr('8125')||chr('700')||chr('8217'), '`````'));  
    
  RETURN inBayer;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.07.23                                                       *
*/

-- SELECT * FROM gpGet_BayerAscii (inBayer := '')