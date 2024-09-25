-- Function: lpInsertUpdate_Movement_PromoTrade()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PromoTrade(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inContractId            Integer    , -- �������  
    IN inPaidKindId            Integer    , 
    IN inPromoItemId           Integer    , -- ������ ������
    IN inPromoKindId           Integer    , -- ��� �����
    IN inStartPromo            TDateTime  , -- ���� ������ �����
    IN inEndPromo              TDateTime  , -- ���� ��������� �����
    --IN inCostPromo             TFloat     , -- ��������� ������� � �����
    IN inComment               TVarChar   , -- ����������
    IN inUserId                Integer      -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert      Boolean;
   DECLARE vbOperDateStart TDateTime;
   DECLARE vbOperDateEnd   TDateTime;
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

    --���������� ���� �������� ������
    --vbOperDateEnd := inStartPromo - INTERVAL '1 Day';
    --vbOperDateStart := vbOperDateEnd - INTERVAL '3 Month';
    vbOperDateEnd := inOperDate - INTERVAL '1 Day';
    vbOperDateStart := vbOperDateEnd - INTERVAL '3 Month' + INTERVAL '1 Day';

    -- ��������� ����� � <�������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, (SELECT lfGet.PriceListId
                                                                                         FROM lfGet_Object_Partner_PriceList_onDate (inContractId            := inContractId
                                                                                                                                   , inPartnerId             := NULL
                                                                                                                                   , inMovementDescId        := zc_Movement_Sale()
                                                                                                                                   , inOperDate_order        := inOperDate
                                                                                                                                   , inOperDatePartner       := inOperDate
                                                                                                                                   , inDayPrior_PriceReturn  := NULL
                                                                                                                                   , inIsPrior               := NULL
                                                                                                                                   , inOperDatePartner_order := inOperDate
                                                                                                                                    ) AS lfGet
                                                                                        ))
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalTrade(), ioId, OL_Personal.ChildObjectId)
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractConditionKind(), ioId, tmpCC.ContractConditionKindId)
          , lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, tmpCC.ChangePercent)
          , lpInsertUpdate_MovementFloat (zc_MovementFloat_DelayDay(), ioId, (COALESCE (tmpCC.DayCalendar,0) + COALESCE (tmpCC.DayBank,0))::TFloat )
    FROM Object AS Object_Contract
         LEFT JOIN (WITH tmpContractCondition_Value_all
                             AS (SELECT *
                                 FROM Object_ContractCondition_ValueView AS View_ContractCondition_Value
                                 WHERE inOperDate BETWEEN View_ContractCondition_Value.StartDate AND View_ContractCondition_Value.EndDate
                                )
                    SELECT tmpContractCondition_Value_all.ContractId
                         , MAX (tmpContractCondition_Value_all.ChangePercent)        :: TFloat AS ChangePercent

                         , MAX (tmpContractCondition_Value_all.DayCalendar) :: TFloat AS DayCalendar
                         , MAX (tmpContractCondition_Value_all.DayBank)     :: TFloat AS DayBank

                         , CASE WHEN 0 <> MAX (tmpContractCondition_Value_all.DayCalendar)
                                    THEN (MAX (zc_Enum_ContractConditionKind_DelayDayCalendar()) :: Integer)
                                WHEN 0 <> MAX (tmpContractCondition_Value_all.DayBank)
                                    THEN MAX(zc_Enum_ContractConditionKind_DelayDayBank()      :: Integer)
                                ELSE 0
                           END :: Integer  AS ContractConditionKindId

                         , MAX (tmpContractCondition_Value_all.StartDate) :: TDateTime AS StartDate
                         , MAX (tmpContractCondition_Value_all.EndDate)   :: TDateTime AS EndDate
                    FROM tmpContractCondition_Value_all
                    GROUP BY tmpContractCondition_Value_all.ContractId
                   ) AS tmpCC
                     ON tmpCC.ContractId = Object_Contract.Id
         -- ������������� ���������
         LEFT JOIN ObjectLink AS OL_Personal
                              ON OL_Personal.ObjectId = Object_Contract.Id
                             AND OL_Personal.DescId   = zc_ObjectLink_Contract_Personal()
    WHERE Object_Contract.Id     = inContractId
      AND Object_Contract.DescId = zc_Object_Contract();

    -- ��� �����
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoKind(), ioId, inPromoKindId);
    -- ������ ������
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoItem(), ioId, inPromoItemId);
    -- ��
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
    
    -- ���� ������ �����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- ���� ��������� �����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);

    -- ���� ������ ����. ������ �� �����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, vbOperDateStart);
    -- ���� ��������� ����. ������ �� �����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, vbOperDateEnd);

    --��������� ������� � �����
    --PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CostPromo(), ioId, inCostPromo);

     -- ����������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- ������ �������
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), ioId, (SELECT DISTINCT tmp.SignInternalId
                                                                                            FROM lpSelect_Object_SignInternalItem ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_SignInternal())
                                                                                                                                 , (SELECT Movement.DescId FROM Movement WHERE Movement.Id = ioId)
                                                                                                                                 , 0, 0) AS tmp
                                                                                           )
                                              );

     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <���� ��������> - ��� �������� � ��� ����., ����� ���� ��������
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� ����� � <������������>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (ioId);

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