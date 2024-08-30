-- Function: lpInsertUpdate_Movement_PromoTrade()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PromoTrade(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������  
    IN inContractId            Integer    , -- �������  
    IN inPromoItemId           Integer    , -- ������ ������
    IN inPromoKindId           Integer    , -- ��� �����
    IN inStartPromo            TDateTime  , -- ���� ������ �����
    IN inEndPromo              TDateTime  , -- ���� ��������� �����
    IN inCostPromo             TFloat     , -- ��������� ������� � �����
    IN inComment               TVarChar   , -- ����������
    IN inUserId                Integer      -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ��������
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION '������.�������� ������ ���� ��������� <%>.', inOperDate;
    END IF;
       
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PromoTrade(), inInvNumber, inOperDate, NULL, 0);
   
    -- 
    IF ioId <=0 -- OR inUserId = 5
    THEN
        RAISE EXCEPTION '������.���� <%> <= 0. <%> � <%> �� <%>.'
                      , ioId
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_PromoTrade())
                      , inInvNumber
                      , zfConvert_DateToString (inOperDate)
                       ;
    END IF;
 
    -- ��������� ����� � <�������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
  
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, OL_PriceList.ChildObjectId)
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalTrade(), ioId, OL_PersonalTrade.ChildObjectId)
          , lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, tmpCC.ChangePercent)
    FROM Object AS tmp                     
         LEFT JOIN tmpContractCondition_Value AS tmpCC ON tmpCC.ContractId = tmp.Id  
         LEFT JOIN ObjectLink AS OL_PersonalTrade
                              ON OL_PersonalTrade.ObjectId = Object_Contract_View.ContractId 
                             AND OL_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade() 
         LEFT JOIN ObjectLink AS OL_PriceList
                              ON OL_PriceList.ObjectId = Object_Contract_View.ContractId
                             AND OL_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
    WHERE tmp.Id = inContractId
      AND tmp.DescId = zc_Object_ContractId;
   
    -- ��� �����
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoKind(), ioId, inPromoKindId);
    -- ������ ������
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoItem(), ioId, inPromoItemId);

    -- ���� ������ �����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- ���� ��������� �����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo); 
    
    -- ���� ������ ����. ������ �� �����
    --PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
    -- ���� ��������� ����. ������ �� �����
    --PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);
    
    --��������� ������� � �����
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CostPromo(), ioId, inCostPromo)

     -- ����������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

        
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
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.08.24         *
*/