-- Function: gpInsertUpdate_MovementItem_Wages_Summa()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages_Summa(INTEGER, INTEGER, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Wages_Summa(
    IN ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inHolidaysHospital    TFloat    , -- ������ / ����������
    IN inMarketing           TFloat    , -- ���������
    IN inDirector            TFloat    , -- ��������. ������ / ������
    IN inIlliquidAssets      TFloat    , -- ���������
    IN inPenaltySUN          TFloat    , -- ������������ ����� �� ���
    IN inPenaltyExam         TFloat    , -- ����� �� ����� ��������
    IN inApplicationAward    TFloat    , -- ���. ����������
    IN inAmountCard          TFloat    , -- �� �����
    IN inisIssuedBy          Boolean   , -- ������
   OUT outAmountHand         TFloat    , -- �� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbOperDate TDateTime;
   
   DECLARE vbUserWagesId Integer;
   DECLARE vbisIssuedBy Boolean;
   DECLARE vbHolidaysHospital TFloat;
   DECLARE vbMarketing TFloat;
   DECLARE vbDirector TFloat;
   DECLARE vbIlliquidAssets TFloat;
   DECLARE vbPenaltySUN TFloat;
   DECLARE vbPenaltyExam TFloat;
   DECLARE vbApplicationAward TFloat;
   DECLARE vbAmountCard TFloat;
   DECLARE vbisWagesCheckTesting Boolean;
   DECLARE vbUserUpdateMarketing Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (ioId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �������� �� ��������.';
    END IF;
    
    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF COALESCE(inIlliquidAssets, 0) > 0
    THEN
        RAISE EXCEPTION '������. ����� ���������� ������ ���� ������ ��� ����� ����.';    
    END IF;
    
    SELECT COALESCE(ObjectBoolean_CashSettings_WagesCheckTesting.ValueData, FALSE)  AS isWagesCheckTesting
         , COALESCE(ObjectLink_CashSettings_UserUpdateMarketing.ChildObjectId, 0)   AS UserUpdateMarketing
    INTO vbisWagesCheckTesting
       , vbUserUpdateMarketing 
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_WagesCheckTesting
                                 ON ObjectBoolean_CashSettings_WagesCheckTesting.ObjectId = Object_CashSettings.Id 
                                AND ObjectBoolean_CashSettings_WagesCheckTesting.DescId = zc_ObjectBoolean_CashSettings_WagesCheckTesting()
         LEFT JOIN ObjectLink AS ObjectLink_CashSettings_UserUpdateMarketing
                ON ObjectLink_CashSettings_UserUpdateMarketing.ObjectId = Object_CashSettings.Id
               AND ObjectLink_CashSettings_UserUpdateMarketing.DescId = zc_ObjectLink_CashSettings_UserUpdateMarketing()
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;
        
    IF EXISTS(SELECT 1 FROM MovementItem WHERE ID = ioId AND MovementItem.DescId = zc_MI_Sign())
    THEN

      vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

      IF COALESCE(inHolidaysHospital, 0) <> 0 OR
         COALESCE(inMarketing, 0) <> 0 OR
         COALESCE(inDirector, 0) <> 0  OR
         COALESCE(inIlliquidAssets, 0) <> 0 OR
         COALESCE(inPenaltySUN, 0) <> 0 OR
         COALESCE(inPenaltyExam, 0) <> 0 OR
         COALESCE(inApplicationAward, 0) <> 0 OR
         COALESCE(inAmountCard, 0) <> 0
      THEN
        RAISE EXCEPTION '������. ��� �������������� �������� ����� �������� ������ ������� "������".';      
      END IF;
    
       -- ��������� �������� <���� ������>
      IF inisIssuedBy <> COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE DescID = zc_MIBoolean_isIssuedBy() AND MovementItemID = ioId), FALSE)
      THEN
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_IssuedBy(), ioId, CURRENT_TIMESTAMP);
      
         -- ��������� �������� <������>
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), ioId, inisIssuedBy);
      

        -- ��������� ��������
        PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, False);    
      END IF;

      SELECT MovementItem.Amount 
      INTO outAmountHand
      FROM  MovementItem
      WHERE MovementItem.Id = ioId;
    ELSE
    
      SELECT MovementItem.ObjectId
           , COALESCE (MIB_isIssuedBy.ValueData, FALSE)
           , COALESCE (MIFloat_HolidaysHospital.ValueData, 0)
           , COALESCE (MIFloat_Marketing.ValueData, 0)
           , COALESCE (MIFloat_Director.ValueData, 0)
           , COALESCE (MIFloat_IlliquidAssets.ValueData, 0)
           , COALESCE (MIFloat_PenaltySUN.ValueData, 0)
           , COALESCE (MIFloat_PenaltyExam.ValueData, 0)
           , COALESCE (MIFloat_ApplicationAward.ValueData, 0)
           , COALESCE (MIF_AmountCard.ValueData, 0)
      INTO vbUserWagesId
         , vbisIssuedBy
         , vbHolidaysHospital
         , vbMarketing
         , vbDirector
         , vbIlliquidAssets
         , vbPenaltySUN
         , vbPenaltyExam
         , vbApplicationAward
         , vbAmountCard   
      FROM  MovementItem

            LEFT JOIN MovementItemFloat AS MIFloat_HolidaysHospital
                                        ON MIFloat_HolidaysHospital.MovementItemId = MovementItem.Id
                                       AND MIFloat_HolidaysHospital.DescId = zc_MIFloat_HolidaysHospital()

            LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                        ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                       AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

            LEFT JOIN MovementItemFloat AS MIFloat_Director
                                        ON MIFloat_Director.MovementItemId = MovementItem.Id
                                       AND MIFloat_Director.DescId = zc_MIFloat_Director()

            LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssets
                                        ON MIFloat_IlliquidAssets.MovementItemId = MovementItem.Id
                                       AND MIFloat_IlliquidAssets.DescId = zc_MIFloat_SummaIlliquidAssets()

            LEFT JOIN MovementItemFloat AS MIFloat_PenaltySUN
                                        ON MIFloat_PenaltySUN.MovementItemId = MovementItem.Id
                                       AND MIFloat_PenaltySUN.DescId = zc_MIFloat_PenaltySUN()

            LEFT JOIN MovementItemFloat AS MIFloat_PenaltyExam
                                        ON MIFloat_PenaltyExam.MovementItemId = MovementItem.Id
                                       AND MIFloat_PenaltyExam.DescId = zc_MIFloat_PenaltyExam()

            LEFT JOIN MovementItemFloat AS MIFloat_ApplicationAward
                                        ON MIFloat_ApplicationAward.MovementItemId = MovementItem.Id
                                       AND MIFloat_ApplicationAward.DescId = zc_MIFloat_ApplicationAward()

            LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                        ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                       AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()
                                         
            LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                          ON MIB_isIssuedBy.MovementItemId = MovementItem.Id
                                         AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

      WHERE MovementItem.Id = ioId;
                            
      IF vbisIssuedBy = TRUE AND 
         (vbHolidaysHospital <> COALESCE (inHolidaysHospital, 0) OR
          vbMarketing <>  COALESCE (inMarketing, 0) OR
          vbDirector <>  COALESCE (inDirector, 0) OR
          vbIlliquidAssets <>  COALESCE (inIlliquidAssets, 0) OR
          vbPenaltySUN <>  COALESCE (inPenaltySUN, 0) OR
          vbPenaltyExam <>  COALESCE (inPenaltyExam, 0) OR
          vbApplicationAward <>  COALESCE (inApplicationAward, 0) OR
          vbAmountCard <>  COALESCE (inAmountCard, 0))
      THEN
        RAISE EXCEPTION '������. �������� ������. ��������� ���� ���������.';            
      END IF;
        
      IF vbisIssuedBy <> COALESCE (inisIssuedBy, False) OR
         vbHolidaysHospital <> COALESCE (inHolidaysHospital, 0) OR
         vbDirector <>  COALESCE (inDirector, 0) OR
         vbPenaltySUN <>  COALESCE (inPenaltySUN, 0) OR
         vbPenaltyExam <>  COALESCE (inPenaltyExam, 0) OR
         vbApplicationAward <>  COALESCE (inApplicationAward, 0) OR
         vbAmountCard <>  COALESCE (inAmountCard, 0)
      THEN
        vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());
      END IF;        
            
      IF (vbMarketing <>  COALESCE (inMarketing, 0) AND vbUserId <> vbUserUpdateMarketing OR
         vbIlliquidAssets <>  COALESCE (inIlliquidAssets, 0)) AND
         NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 12084491))
      THEN
        RAISE EXCEPTION '��������� ���� "����������" � "����������" ��� ���������.';
      END IF; 
      
      IF vbApplicationAward <> 0 AND vbApplicationAward <> COALESCE (inApplicationAward, 0) AND
         NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())         
      THEN
        PERFORM gpSelect_WagesUser_ZeroApplicationAward(inMovementId := inMovementId, inUserId := vbUserWagesId, inSession := inSession);
      END IF;
      
      IF COALESCE (inApplicationAward, 0) > COALESCE (vbApplicationAward, 0) AND
         ((SELECT SUM(COALESCE (MIFloat_ApplicationAward.ValueData, 0))
           FROM  MovementItem

                 LEFT JOIN MovementItemFloat AS MIFloat_ApplicationAward
                                             ON MIFloat_ApplicationAward.MovementItemId = MovementItem.Id
                                            AND MIFloat_ApplicationAward.DescId = zc_MIFloat_ApplicationAward()

           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.isErased = False) - COALESCE (vbApplicationAward, 0) + COALESCE (inApplicationAward, 0)) > 0 AND
         NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
      THEN
        RAISE EXCEPTION '����� �� <���. ����������> �� ���� ����������� ������ ���� ������ ��� ����� ����.';      
      END IF;

       -- ��������� �������� <������ / ����������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HolidaysHospital(), ioId, inHolidaysHospital);
       -- ��������� �������� <���������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Marketing(), ioId, inMarketing);
       -- ��������� �������� <��������. ������ / ������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Director(), ioId, inDirector);
       -- ��������� �������� < ��������� >
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaIlliquidAssets(), ioId, inIlliquidAssets);
       -- ��������� �������� <������������ ����� �� ���>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PenaltySUN(), ioId, inPenaltySUN);
       -- ��������� �������� <����� �� ����� ��������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PenaltyExam(), ioId, inPenaltyExam);
       -- ��������� �������� <����� �� ����� ��������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ApplicationAward(), ioId, inApplicationAward);

       -- ��������� �������� <�� �����>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountCard(), ioId, inAmountCard);

       -- ��������� �������� <���� ������>
      IF inisIssuedBy <> COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE DescID = zc_MIBoolean_isIssuedBy() AND MovementItemID = ioId), FALSE)
      THEN
      
        SELECT Movement.OperDate 
        INTO vbOperDate
        FROM MovementItem 
             INNER JOIN Movement ON Movement.Id = MovementItem.MovementId 
        WHERE MovementItem.ID = ioId;
      
        IF vbisWagesCheckTesting = TRUE AND inisIssuedBy = TRUE AND vbOperDate >= '01.10.2019' AND 
           NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) AND
           EXISTS(SELECT MovementItem.ObjectId 
                  FROM MovementItem 
                       INNER JOIN ObjectLink AS ObjectLink_User_Member
                                             ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                       INNER JOIN ObjectLink AS ObjectLink_Member_Position
                                             ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                            AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                       INNER JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
                  WHERE MovementItem.ID = ioId
                    AND (Object_Position.ObjectCode = 1 OR Object_Position.ObjectCode = 2 AND vbOperDate >= '01.02.2022')) AND
           NOT EXISTS(SELECT 1
                      FROM Movement

                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()

                           LEFT JOIN MovementItemBoolean AS MIBoolean_Passed
                                                         ON MIBoolean_Passed.DescId = zc_MIBoolean_Passed()
                                                        AND MIBoolean_Passed.MovementItemId = MovementItem.Id
                                                        
                      WHERE Movement.DescId = zc_Movement_TestingUser()
                        AND Movement.OperDate = (SELECT Movement.OperDate 
                                                 FROM MovementItem 
                                                      INNER JOIN Movement ON Movement.Id = MovementItem.MovementId 
                                                 WHERE MovementItem.ID = ioId)
                        AND MovementItem.ObjectId = (SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.ID = ioId)
                        AND COALESCE(MIBoolean_Passed.ValueData, False) = True) AND
           (COALESCE((SELECT MovementItemBoolean.ValueData FROM MovementItemBoolean WHERE MovementItemBoolean.MovementItemID = ioId AND 
                     MovementItemBoolean.DescId = zc_MIBoolean_isTestingUser()), FALSE) = FALSE)
        THEN
          RAISE EXCEPTION '������. ��������� �� ���� �������. ������ �������� ���������.';            
        END IF;

        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_IssuedBy(), ioId, CURRENT_TIMESTAMP);
      
         -- ��������� �������� <������>
        PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), ioId, inisIssuedBy);
      END IF;

      -- ��������� ��������
      PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, False);

      SELECT (MovementItem.Amount + 
              COALESCE (MIFloat_HolidaysHospital.ValueData, 0) + 
              CASE WHEN COALESCE(MIFloat_Marketing.ValueData, 0) > 0 THEN COALESCE(MIFloat_Marketing.ValueData, 0)
                   WHEN COALESCE(MIFloat_Marketing.ValueData, 0) + COALESCE(MIFloat_MarketingRepayment.ValueData, 0) > 0
                   THEN 0 ELSE COALESCE(MIFloat_Marketing.ValueData, 0) + COALESCE(MIFloat_MarketingRepayment.ValueData, 0)  END +
              COALESCE (MIFloat_Director.ValueData, 0) +
              CASE WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) > 0 THEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0)
                   WHEN COALESCE(MIFloat_IlliquidAssets.ValueData, 0) + COALESCE(MIFloat_IlliquidAssetsRepayment.ValueData, 0) > 0
                   THEN 0 ELSE COALESCE(MIFloat_IlliquidAssets.ValueData, 0) + COALESCE(MIFloat_IlliquidAssetsRepayment.ValueData, 0)  END +
              COALESCE (MIFloat_PenaltySUN.ValueData, 0) +
              COALESCE (MIFloat_PenaltyExam.ValueData, 0) +
              COALESCE (MIFloat_ApplicationAward.ValueData, 0) - 
              COALESCE (MIF_AmountCard.ValueData, 0))::TFloat AS AmountHand
      INTO outAmountHand
      FROM  MovementItem

            LEFT JOIN MovementItemFloat AS MIFloat_HolidaysHospital
                                        ON MIFloat_HolidaysHospital.MovementItemId = MovementItem.Id
                                       AND MIFloat_HolidaysHospital.DescId = zc_MIFloat_HolidaysHospital()

            LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                        ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                       AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

            LEFT JOIN MovementItemFloat AS MIFloat_MarketingRepayment
                                        ON MIFloat_MarketingRepayment.MovementItemId = MovementItem.Id
                                       AND MIFloat_MarketingRepayment.DescId = zc_MIFloat_MarketingRepayment()

            LEFT JOIN MovementItemFloat AS MIFloat_Director
                                        ON MIFloat_Director.MovementItemId = MovementItem.Id
                                       AND MIFloat_Director.DescId = zc_MIFloat_Director()

            LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssets
                                        ON MIFloat_IlliquidAssets.MovementItemId = MovementItem.Id
                                       AND MIFloat_IlliquidAssets.DescId = zc_MIFloat_SummaIlliquidAssets()

            LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssetsRepayment
                                        ON MIFloat_IlliquidAssetsRepayment.MovementItemId = MovementItem.Id
                                       AND MIFloat_IlliquidAssetsRepayment.DescId = zc_MIFloat_IlliquidAssetsRepayment()

            LEFT JOIN MovementItemFloat AS MIFloat_PenaltySUN
                                        ON MIFloat_PenaltySUN.MovementItemId = MovementItem.Id
                                       AND MIFloat_PenaltySUN.DescId = zc_MIFloat_PenaltySUN()

            LEFT JOIN MovementItemFloat AS MIFloat_PenaltyExam
                                        ON MIFloat_PenaltyExam.MovementItemId = MovementItem.Id
                                       AND MIFloat_PenaltyExam.DescId = zc_MIFloat_PenaltyExam()

            LEFT JOIN MovementItemFloat AS MIFloat_ApplicationAward
                                        ON MIFloat_ApplicationAward.MovementItemId = MovementItem.Id
                                       AND MIFloat_ApplicationAward.DescId = zc_MIFloat_ApplicationAward()

            LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                        ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                       AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()

      WHERE MovementItem.Id = ioId;
  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.08.19                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Wages_Summa (, inSession:= '2')