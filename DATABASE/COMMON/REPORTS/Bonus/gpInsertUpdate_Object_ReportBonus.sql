-- Function: gpInsertUpdate_Object_ReportBonus()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReportBonus (Integer, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReportBonus(
 INOUT ioId                  Integer   , --
    IN inMonth               TDateTime , --
    IN inJuridicalId         Integer   , --
    IN inPartnerId           Integer   , --
    IN inisSend              Boolean   , -- �������
   OUT outisSend             Boolean   , -- �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    outisSend := inisSend;
    
    --���� isSend =True � �� ����� ��� �������� - ����� ���������� ������� �� �������� = true
    IF COALESCE (ioId,0) <> 0 AND inisSend = True
    THEN 
        UPDATE Object SET isErased = TRUE WHERE Object.Id = ioId AND Object.DescId = zc_Object_ReportBonus();
    END IF;

    --���� isSend =False - � ����� ������� ��� ���� ������ ������� �� �������� = false
    IF COALESCE (ioId,0) <> 0 AND inisSend = False
    THEN 
        UPDATE Object SET isErased = False WHERE Object.Id = ioId AND Object.DescId = zc_Object_ReportBonus();
    END IF;
    
    --���� isSend =False - � ����� ������� ��� �� �������� ����� ��� ���������
    IF COALESCE (ioId,0) = 0 AND inisSend = False
    THEN
         -- ��������� <������>
         ioId := lpInsertUpdate_Object (ioId, zc_Object_ReportBonus(), 0, '');
         
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectDate (zc_Object_ReportBonus_Month(), ioId, DATE_TRUNC ('Month',inMonth) );

         -- ��������� ����� � <����������� ����>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_Juridical(), ioId, inJuridicalId);
         -- ��������� ����� � <����������>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportBonus_Partner(), ioId, inPartnerId);

    END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.09.20         * 
*/


-- ����
--