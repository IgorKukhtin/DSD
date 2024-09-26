-- Function: lpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer);

/*DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer); */

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Promo(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inPromoKindId           Integer    , -- ��� �����
    IN inPriceListId           Integer    , -- ����� ����
    IN inStartPromo            TDateTime  , -- ���� ������ �����
    IN inEndPromo              TDateTime  , -- ���� ��������� �����
    IN inStartSale             TDateTime  , -- ���� ������ �������� �� ��������� ����
    IN inEndSale               TDateTime  , -- ���� ��������� �������� �� ��������� ����
    IN inEndReturn             TDateTime  , -- ���� ��������� ��������� �� ��������� ����
    IN inOperDateStart         TDateTime  , -- ���� ������ ����. ������ �� �����
    IN inOperDateEnd           TDateTime  , -- ���� ��������� ����. ������ �� �����
 INOUT ioMonthPromo            TDateTime  , -- ����� �����
    IN inCheckDate             TDateTime  , -- ���� ������������
    IN inChecked               Boolean    , -- �����������
    IN inIsPromo               Boolean    , -- �����   
    IN inisCost                Boolean    , -- �������
    IN inCostPromo             TFloat     , -- ��������� ������� � �����
    IN inComment               TVarChar   , -- ����������
    IN inCommentMain           TVarChar   , -- ���������� (�����)
    IN inUnitId                Integer    , -- �������������
    IN inPersonalTradeId       Integer    , -- ������������� ������������� ������������� ������
    IN inPersonalId            Integer    , -- ������������� ������������� �������������� ������ 
    IN inPaidKindId            Integer    , 
--    IN inSignInternalId        Integer    , 
    IN inUserId                Integer      -- ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ��������
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION '������.�������� ������ ���� ��������� <%>.', inOperDate;
    END IF;
    -- ��������
    IF inStartSale <> DATE_TRUNC ('DAY', inStartSale)
    THEN
        RAISE EXCEPTION '������.�������� ������ ������ �������� �� ��������� ���� <%>.', inStartSale;
    END IF;
    -- ��������
    IF inEndSale <> DATE_TRUNC ('DAY', inEndSale)
    THEN
        RAISE EXCEPTION '������.�������� ������ ��������� �������� �� ��������� ���� <%>.', inEndSale;
    END IF;
    -- ��������
    IF inEndReturn <> DATE_TRUNC ('DAY', inEndReturn)
    THEN
        RAISE EXCEPTION '������.�������� ������ ��������� ��������� �� ��������� ���� <%>.', inEndReturn;
    END IF;
    -- ��������
    IF COALESCE (inEndReturn, zc_DateStart()) < COALESCE (inEndSale, zc_DateEnd())
    THEN
        RAISE EXCEPTION '������.���� ��������� ��������� �� ��������� ���� <%> �� ����� ���� ������ ��� ���� ��������� �������� �� ��������� ���� <%>.', DATE (inEndReturn), DATE (inEndSale);
    END IF;

    
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Promo(), inInvNumber, inOperDate, NULL, 0);
   
    -- 
    IF ioId <=0 -- OR inUserId = 5
    THEN
        RAISE EXCEPTION '������.���� <%> <= 0. <%> � <%> �� <%>.'
                      , ioId
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Promo())
                      , inInvNumber
                      , zfConvert_DateToString (inOperDate)
                       ;
    END IF;
 
    -- ��������� ����� � <�� ���� (�������������)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    -- ��� �����
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoKind(), ioId, inPromoKindId);
    -- ����� ����
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, inPriceListId);
    -- ��
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

    -- ���� ������ �����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- ���� ��������� �����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);
    -- ���� ������ �������� �� ��������� ����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
    -- ���� ��������� �������� �� ��������� ����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndSale(), ioId, inEndSale);
    -- ���� ��������� ��������� �� ��������� ����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndReturn(), ioId, inEndReturn);
    -- ���� ������ ����. ������ �� �����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
    -- ���� ��������� ����. ������ �� �����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);
    
    --���� ����� = TRUE ���������� �����
    IF inIsPromo = TRUE
    THEN
      -- ���� ... ����� ����� ���������� � ����������� �� zc_MovementDate_EndSale (���� ���� 10,11, � �� ����� ���, ����� ��� ���. �����, ���� � 1 �� 9, ����� ����� ���� �����) --06.07.2020
      ioMonthPromo:=(CASE WHEN inEndSale >= '01.06.2022' THEN DATE_TRUNC ('MONTH', inEndSale) WHEN EXTRACT (DAY FROM inEndSale) BETWEEN 1 AND 9 THEN DATE_TRUNC ('MONTH', (inEndSale - INTERVAL '1 Month') ) ELSE DATE_TRUNC ('MONTH', inEndSale) END) :: TDateTime;
    END IF;
    
    -- ����� �����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Month(), ioId, ioMonthPromo);
    
    -- ���� ������������ ��������� ������ �����  inChecked = TRUE
    IF inChecked = TRUE
    THEN
        -- ���� ������������ 
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), ioId, inCheckDate);
    ELSE 
        -- ���� ������������ 
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), ioId, NULL);
    END IF;
    
    -- ��������� �������� <�����������>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);
    -- ��������� �������� <�����>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo(), ioId, inIsPromo);
    -- ��������� �������� <�������>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Cost(), ioId, inIsCost);
         
    -- ��������� ������� � �����
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CostPromo(), ioId, inCostPromo);
    -- ����������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    -- ���������� (�����)
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentMain(), ioId, inCommentMain);

    -- �������������
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- ������������� ������������� ������������� ������
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalTrade(), ioId, inPersonalTradeId);
    -- ������������� ������������� �������������� ������
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
    -- ������ �������
    --PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), ioId, inSignInternalId);
        
     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������> - ��� �������� � ��� ����., ����� ���� ��������
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� ����� � <������������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 06.07.20         *
 01.08.17         *
 25.07.17         *
 31.10.15                                                                       *
*/