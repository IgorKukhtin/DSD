-- Function: gpUpdate_Movement_Loss_SummaFund()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Loss_SummaFund  (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Loss_SummaFund(
    IN inMovementId           Integer,  -- ���� ���������
    IN inSummaFund            TFloat,   -- ����� �����
    IN inSession              TVarChar  -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId             Integer;
  DECLARE vbStatusId           Integer;
  DECLARE vbTotalSumm          TFloat;
  DECLARE vbRetailFund         TFloat;
  DECLARE vbSummaFund          TFloat;
  DECLARE vbRetailFundUsed     TFloat;
  DECLARE vbOperDate           TDateTime;
  DECLARE vbArticleLossId      Integer;
  DECLARE vbUnitId             Integer;
BEGIN
    vbUserId:= inSession;

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_WorkWithTheFund()))
    THEN
      RAISE EXCEPTION '������. �������� ��� �������� ��� �������� ��� ���������!.';
    END IF;

    IF inSummaFund < 0
    THEN
      RAISE EXCEPTION '������. ����� �� ����� ������ ���� ������ ��� ����� 0.';
    END IF;

    -- ��������� ���������
    SELECT Movement.StatusId
         , Movement.OperDate
         , MovementLinkObject_Unit.ObjectId
         , COALESCE(Round(MovementFloat_TotalSumm.ValueData, 2), 0)::TFloat   AS TotalSumm
         , COALESCE(ObjectFloat_Retail_Fund.ValueData , 0)::TFloat            AS RetailFund
         , COALESCE(ObjectFloat_Retail_FundUsed.ValueData, 0)::TFloat         AS RetailFundUsed
         , COALESCE(MovementFloat_SummaFund.ValueData, 0)::TFloat             AS SummaFund
         , COALESCE(MovementLinkObject_ArticleLoss.ObjectId, 0)               AS ArticleLossID 
    INTO
        vbStatusId,
        vbOperDate, 
        vbUnitId,
        vbTotalSumm,
        vbRetailFund,
        vbRetailFundUsed,
        vbSummaFund,
        vbArticleLossId
    FROM Movement
         LEFT JOIN MovementFloat AS MovementFloat_SummaFund
                                 ON MovementFloat_SummaFund.MovementId =  Movement.Id
                                AND MovementFloat_SummaFund.DescId = zc_MovementFloat_SummaFund()
         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                      ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                     AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                              ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                             AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

         LEFT JOIN ObjectFloat AS ObjectFloat_Retail_Fund
                               ON ObjectFloat_Retail_Fund.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                              AND ObjectFloat_Retail_Fund.DescId = zc_ObjectFloat_Retail_Fund()

         LEFT JOIN ObjectFloat AS ObjectFloat_Retail_FundUsed
                               ON ObjectFloat_Retail_FundUsed.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                              AND ObjectFloat_Retail_FundUsed.DescId = zc_ObjectFloat_Retail_FundUsed()
    WHERE Movement.Id = inMovementId;

    IF inSummaFund > 0
    THEN

      IF vbStatusId <> zc_Enum_Status_Complete()
      THEN
        RAISE EXCEPTION '������. ������� �� �������� ��������� ����� �� ����� ���������.';
      END IF;

      IF inSummaFund > vbTotalSumm
      THEN
        RAISE EXCEPTION '������. ����� �� ����� ��������� ����� ���������!.';
      END IF;

      IF (vbRetailFund - vbRetailFundUsed + vbSummaFund - inSummaFund) < 0
      THEN
        RAISE EXCEPTION '������. ��������� ����� �������� ������� �����.!.';
      END IF;

      -- ��������� �������� <����� ����������>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummaFund(), inMovementId, inSummaFund);
    ELSE

      -- ��������� �������� <����� ����������>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummaFund(), inMovementId, inSummaFund);
    END IF;
    
    PERFORM gpSelect_Calculation_Retail_FundUsed(inSession);

    --�������� ������� �������� � ��������
    IF COALESCE(vbArticleLossId, 0) IN (13892113, 23653195)
    THEN
      PERFORM gpInsertUpdate_MovementItem_WagesFullCharge (vbUnitId, vbOperDate, inSession); 
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.  ������ �.�.
 27.04.20                                                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Loss_SummaFund (inMovementId:= 18340672, inSummaFund := 1000, inSession:= '3')
