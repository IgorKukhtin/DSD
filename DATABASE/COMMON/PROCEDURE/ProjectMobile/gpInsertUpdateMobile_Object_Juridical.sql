-- Function: gpInsertUpdateMobile_Object_Juridical

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Juridical (Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Juridical (Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Object_Juridical (
 INOUT ioId               Integer  , -- ���� ������� <����������� ����>
    IN inGUID             TVarChar , -- ���������� ���������� �������������
    IN inName             TVarChar , -- �������� ������� <����������� ����>
    -- IN inJuridicalGroupId Integer  , -- ������ ����������� ���
    IN inSession          TVarChar   -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);


      -- testm
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION '������.��� ����.';
      END IF;


      IF COALESCE (inGUID, '') = ''
      THEN
           RAISE EXCEPTION '������. �� ����� ���������� ���������� �������������';
      END IF;
   
      -- ���� ��. ���� �� �������� ����������� ����������� ��������������
      SELECT ObjectString_Juridical_GUID.ObjectId
      INTO vbId
      FROM ObjectString AS ObjectString_Juridical_GUID
           JOIN Object AS Object_Juridical
                       ON Object_Juridical.Id = ObjectString_Juridical_GUID.ObjectId
                      AND Object_Juridical.DescId = zc_Object_Juridical()
      WHERE ObjectString_Juridical_GUID.DescId = zc_ObjectString_Juridical_GUID()
        AND ObjectString_Juridical_GUID.ValueData = inGUID;

      -- ��������� ��. ����
      ioId:= gpInsertUpdate_Object_Juridical (ioId               := COALESCE (vbId, 0)        -- ���� ������� <����������� ����>
                                            , inCode             := 0                         -- �������� <��� ������������ ����>
                                            , inName             := inName                    -- �������� ������� <����������� ����>
                                            , inGLNCode          := NULL                      -- ��� GLN
                                            , inisCorporate      := false                     -- ������� ���� �� ������������� ��� ����������� ����
                                            , inisTaxSummary     := false                     -- ������� ������� ���������
                                            , inisDiscountPrice  := false                     -- ������ � ��������� ���� �� �������
                                            , inisPriceWithVAT   := false                     -- ������ � ��������� ���� � ��� (��/���)
                                            , inDayTaxSummary    := 0                         -- ���-�� ���� ��� ������� ���������
                                            , inJuridicalGroupId := 8362                      -- ������ ����������� ��� (03-����������)
                                            , inGoodsPropertyId  := 0                         -- �������������� ������� �������
                                            , inRetailId         := 0                         -- �������� ����
                                            , inRetailReportId   := 0                         -- �������� ����(�����)
                                            , inInfoMoneyId      := zc_Enum_InfoMoney_30101() -- ������ ���������� (������� ���������)
                                            , inPriceListId      := 0                         -- �����-����
                                            , inPriceListPromoId := 0                         -- �����-����(���������)
                                            , inStartPromo       := NULL                      -- ���� ������ �����
                                            , inEndPromo         := NULL                      -- ���� ��������� �����
                                            , inSession          := inSession                 -- ������� ������������
                                             );

      -- ��������� �������� <���������� ���������� �������������>
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_GUID(), ioId, inGUID);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 05.04.17                                                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdateMobile_Object_Juridical (ioId:= 0, inGUID:= '{CCCCEF83-D391-4CDB-A471-AF9DD07AC7D9}', inName:= '��. ���� � ���. ����������', inSession:= zfCalc_UserAdmin())
