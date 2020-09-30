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
    
    --������� �����, ����� ��� ���� �������
    IF COALESCE (ioId,0) = 0
    THEN
        ioId := (SELECT Object_ReportBonus.Id
                 FROM Object AS Object_ReportBonus
                      INNER JOIN ObjectDate AS ObjectDate_Month
                                           ON ObjectDate_Month.ObjectId = Object_ReportBonus.Id
                                          AND ObjectDate_Month.DescId = zc_Object_ReportBonus_Month()
                                          AND ObjectDate_Month.ValueData =  DATE_TRUNC ('Month', inMonth)
                      INNER JOIN ObjectLink AS ObjectLink_Juridical
                                            ON ObjectLink_Juridical.ObjectId = Object_ReportBonus.Id
                                           AND ObjectLink_Juridical.DescId = zc_ObjectLink_ReportBonus_Juridical()
                                           AND ObjectLink_Juridical.ChildObjectId = inJuridicalId
                      LEFT JOIN ObjectLink AS ObjectLink_Partner
                                           ON ObjectLink_Partner.ObjectId = Object_ReportBonus.Id
                                          AND ObjectLink_Partner.DescId = zc_ObjectLink_ReportBonus_Partner()
                 WHERE Object_ReportBonus.DescId = zc_Object_ReportBonus()
                   AND (ObjectLink_Partner.ChildObjectId = inPartnerId OR inPartnerId = 0));
    END IF;
    
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