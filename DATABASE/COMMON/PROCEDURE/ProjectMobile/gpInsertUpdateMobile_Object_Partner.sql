-- Function: gpInsertUpdateMobile_Object_Partner

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Partner (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, 
                                                             TFloat, TFloat, TVarChar, Integer, TVarChar, TVarChar, TVarChar, 
                                                             Integer, TVarChar, TVarChar, TVarChar, Integer,
                                                             Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Object_Partner (
 INOUT ioId               Integer  ,  -- ���� ������� <����������>
    IN inGUID             TVarChar ,  -- ���������� ���������� �������������
    IN inShortName        TVarChar ,  -- ������� ������������
        
    IN inHouseNumber      TVarChar ,  -- ����� ����
    IN inCaseNumber       TVarChar ,  -- ����� �������
    IN inRoomNumber       TVarChar ,  -- ����� ��������
    IN inPrepareDayCount  TFloat   ,  -- �� ������� ���� ����������� �����
    IN inDocumentDayCount TFloat   ,  -- ����� ������� ���� ����������� �������������
    
    IN inJuridicalGUID    TVarChar ,  -- ����������� ���� (���������� ���������� �������������)

    IN inAreaId           Integer  ,  -- ������
    IN inRegionName       TVarChar ,  -- ������������ �������
    IN inProvinceName     TVarChar ,  -- ������������ �����
    IN inCityName         TVarChar ,  -- ������������ ���������� �����
    IN inCityKindId       Integer  ,  -- ��� ����������� ������
    IN inProvinceCityName TVarChar ,  -- ������������ ������ ����������� ������
    IN inPostalCode       TVarChar ,  -- ������
    IN inStreetName       TVarChar ,  -- ������������ �����
    IN inStreetKindId     Integer  ,  -- ��� �����

    IN inValue1           Boolean  ,  -- ����������� ��������
    IN inValue2           Boolean  ,  -- �������
    IN inValue3           Boolean  ,  -- �����
    IN inValue4           Boolean  ,  -- �������
    IN inValue5           Boolean  ,  -- �������
    IN inValue6           Boolean  ,  -- �������
    IN inValue7           Boolean  ,  -- �����������
    
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbPriceListId_def Integer;
   DECLARE vbId Integer;
BEGIN
      
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      IF COALESCE (inJuridicalGUID, '') = ''
      THEN
           RAISE EXCEPTION '������. �� ����� ���������� ���������� ������������� ��.����';
      END IF;

      -- ���� ��.���� �� �������� ����������� ����������� ��������������
      SELECT ObjectString_Juridical_GUID.ObjectId
      INTO vbJuridicalId
      FROM ObjectString AS ObjectString_Juridical_GUID
           JOIN Object AS Object_Juridical
                       ON Object_Juridical.Id = ObjectString_Juridical_GUID.ObjectId
                      AND Object_Juridical.DescId = zc_Object_Juridical()
      WHERE ObjectString_Juridical_GUID.DescId = zc_ObjectString_Juridical_GUID()
        AND ObjectString_Juridical_GUID.ValueData = inJuridicalGUID;

      IF COALESCE (inGUID, '') = ''
      THEN
           RAISE EXCEPTION '������. �� ����� ���������� ���������� �������������';
      END IF;

      SELECT PersonalId, PriceListId_def INTO vbPersonalId, vbPriceListId_def FROM gpGetMobile_Object_Const (inSession);

      -- ���� ����������� �� �������� ����������� ����������� ��������������
      SELECT ObjectString_Partner_GUID.ObjectId
      INTO vbId
      FROM ObjectString AS ObjectString_Partner_GUID
           JOIN Object AS Object_Partner
                       ON Object_Partner.Id = ObjectString_Partner_GUID.ObjectId
                      AND Object_Partner.DescId = zc_Object_Partner()
      WHERE ObjectString_Partner_GUID.DescId = zc_ObjectString_Partner_GUID()
        AND ObjectString_Partner_GUID.ValueData = inGUID;

      ioId:= (SELECT tmpPartner.ioId FROM gpInsertUpdate_Object_Partner(ioId               := COALESCE (vbId, 0)::Integer -- ���� ������� <����������> 
                                                                      , inCode             := 0                  -- ��� ������� <����������>
                                                                      , inShortName        := inShortName        -- ������� ������������
                                                                      , inGLNCode          := ''::TVarChar       -- ��� GLN
                                                                      , inGLNCodeJuridical := ''::TVarChar       -- ��� GLN - ����������
                                                                      , inGLNCodeRetail    := ''::TVarChar       -- ��� GLN - ����������
                                                                      , inGLNCodeCorporate := ''::TVarChar       -- ��� GLN - ���������
                                                                         
                                                                      , inHouseNumber      := inHouseNumber      -- ����� ����
                                                                      , inCaseNumber       := inCaseNumber       -- ����� �������
                                                                      , inRoomNumber       := inRoomNumber       -- ����� ��������
                                                                      , inStreetId         := 0                  -- �����/��������  
                                                                      , inPrepareDayCount  := inPrepareDayCount  -- �� ������� ���� ����������� �����
                                                                      , inDocumentDayCount := inDocumentDayCount -- ����� ������� ���� ����������� �������������
                                                                       
                                                                      , inEdiOrdspr        := false -- EDI - �������������
                                                                      , inEdiInvoice       := false -- EDI - ����
                                                                      , inEdiDesadv        := false -- EDI - �����������
                                                                       
                                                                      , inJuridicalId      := vbJuridicalId -- ����������� ����
                                                                      , inRouteId          := 0             -- �������
                                                                      , inRouteSortingId   := 0             -- ���������� ���������
                                                                       
                                                                      , inMemberTakeId     := 0            -- ��� ����(��������� ����������)
                                                                      , inPersonalId       := 0            -- ��� ���� (������������� ����)
                                                                      , inPersonalTradeId  := vbPersonalId -- ��� ����(��������)
                                                                      , inAreaId           := inAreaId     -- ������
                                                                      , inPartnerTagId     := 0            -- ������� �������� �����
                                                                       
                                                                      , inGoodsPropertyId  := 0 -- �������������� ������� �������
                                                                       
                                                                      , inPriceListId      := vbPriceListId_def -- �����-����
                                                                      , inPriceListPromoId := 0                 -- �����-����(���������)
                                                                      , inStartPromo       := NULL              -- ���� ������ �����
                                                                      , inEndPromo         := NULL              -- ���� ��������� �����
                                                                       
                                                                      , inRegionName       := inRegionName       -- ������������ �������
                                                                      , inProvinceName     := inProvinceName     -- ������������ �����
                                                                      , inCityName         := inCityName         -- ������������ ���������� �����
                                                                      , inCityKindId       := inCityKindId       -- ��� ����������� ������
                                                                      , inProvinceCityName := inProvinceCityName -- ������������ ������ ����������� ������
                                                                      , inPostalCode       := inPostalCode       -- ������
                                                                      , inStreetName       := inStreetName       -- ������������ �����
                                                                      , inStreetKindId     := inStreetKindId     -- ��� �����

                                                                      , inValue1           := inValue1  -- ����������� ��������
                                                                      , inValue2           := inValue2  -- �������
                                                                      , inValue3           := inValue3  -- �����
                                                                      , inValue4           := inValue4  -- �������
                                                                      , inValue5           := inValue5  -- �������
                                                                      , inValue6           := inValue6  -- �������
                                                                      , inValue7           := inValue7  -- �����������
                                                                       
                                                                      , inSession          := inSession -- ������ ������������
                                                                       ) AS tmpPartner);
   
      -- ��������� �������� <���������� ���������� �������������>
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_GUID(), ioId, inGUID);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 05.04.17                                                         *
*/

-- ����
/* SELECT * FROM gpInsertUpdateMobile_Object_Partner (ioId               := 0
                                                    , inGUID             := '{FD0D2968-FE5A-49B8-AC9B-29E0FC741E91}'
                                                    , inShortName        := '���������� � ���. ����������'

                                                    , inHouseNumber      := '5'  -- ����� ����
                                                    , inCaseNumber       := '1'  -- ����� �������
                                                    , inRoomNumber       := '37' -- ����� ��������
                                                    , inPrepareDayCount  := 1    -- �� ������� ���� ����������� �����
                                                    , inDocumentDayCount := 1    -- ����� ������� ���� ����������� �������������
                                                   
                                                    , inJuridicalGUID    := '{CCCCEF83-D391-4CDB-A471-AF9DD07AC7D9}' -- ����������� ���� (���������� ���������� �������������)

                                                    , inAreaId           := 310820          -- ������
                                                    , inRegionName       := '����������'    -- ������������ �������
                                                    , inProvinceName     := '���������'     -- ������������ �����
                                                    , inCityName         := '�����'         -- ������������ ���������� �����
                                                    , inCityKindId       := 310784          -- ��� ����������� ������
                                                    , inProvinceCityName := ''              -- ������������ ������ ����������� ������
                                                    , inPostalCode       := '45034'         -- ������
                                                    , inStreetName       := '�������������' -- ������������ �����
                                                    , inStreetKindId     := 310787          -- ��� �����

                                                    , inValue1           := true   -- ����������� ��������
                                                    , inValue2           := false  -- �������
                                                    , inValue3           := true   -- �����
                                                    , inValue4           := false  -- �������
                                                    , inValue5           := true   -- �������
                                                    , inValue6           := false  -- �������
                                                    , inValue7           := false  -- �����������

                                                    , inSession          := zfCalc_UserAdmin()
                                                     )
*/
