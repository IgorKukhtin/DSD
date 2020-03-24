-- Function: gpUpdate_Movement_Check_ConfirmedKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ConfirmedKind (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_ConfirmedKind (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_ConfirmedKind(
    IN inMovementId        Integer  , -- 
    IN inDescName          TVarChar , -- ����� ��������
   OUT ouConfirmedKindName TVarChar , -- ������� � ���� ����� ��������
   OUT outMessageText      Text     , -- �������, ���� ���� ������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbConfirmedKindId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);


    -- ����� ������ ��������
    vbConfirmedKindId:= (SELECT Object.Id FROM ObjectString JOIN Object ON Object.Id = ObjectString.ObjectId AND Object.DescId = zc_Object_ConfirmedKind() WHERE LOWER (ObjectString.ValueData) = LOWER (inDescName) AND ObjectString.DescId = zc_ObjectString_Enum());
    ouConfirmedKindName:= COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = vbConfirmedKindId), '');

    -- �������� - ?����������� ������ ������ �� ��������� 7 ����? + ���� ���-�� ������ �� ����������
    IF NOT EXISTS (SELECT 1
                   FROM Movement
                        INNER JOIN MovementLinkObject AS MLO ON MLO.MovementId = Movement.Id
                                                            AND MLO.DescId = zc_MovementLinkObject_ConfirmedKind()
                                                            AND MLO.ObjectId = CASE WHEN vbConfirmedKindId = zc_Enum_ConfirmedKind_Complete()
                                                                                         THEN zc_Enum_ConfirmedKind_UnComplete()
                                                                                    WHEN vbConfirmedKindId = zc_Enum_ConfirmedKind_UnComplete()
                                                                                         THEN zc_Enum_ConfirmedKind_Complete()
                                                                               END
                        /*INNER JOIN MovementString AS MS ON MS.MovementId = Movement.Id
                                                       AND MS.DescId = zc_MovementString_InvNumberOrder()
                                                       AND MS.ValueData <> ''*/
                   WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Check() AND Movement.OperDate >= CURRENT_DATE - INTERVAL '7 DAY'
                  )
    THEN
        ouConfirmedKindName:= '';
        vbConfirmedKindId:= 0;
        RAISE EXCEPTION '������. �������� ���� VIP ����';
    END IF;

    IF vbConfirmedKindId > 0
    THEN
        -- �������� - ������ ���� ��� �������������
        IF vbConfirmedKindId = zc_Enum_ConfirmedKind_Complete()
        THEN
            -- ����������
            vbUnitId:= (SELECT MovementLinkObject.ObjectId
                        FROM MovementLinkObject 
                        WHERE MovementLinkObject.MovementId = inMovementId 
                          AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit());

            -- �������� ��� ���� �������
            outMessageText:= '������.������ "��� �����" ��� �� ������������: '
                                || (WITH tmpFrom AS (SELECT MI.ObjectId AS GoodsId, SUM (MI.Amount) AS Amount 
                                                     FROM MovementItem AS MI 
                                                     WHERE MI.MovementId = inMovementId 
                                                       AND MI.DescId = zc_MI_Master()
                                                       AND MI.Amount > 0 
                                                       AND MI.isErased = FALSE 
                                                     GROUP BY MI.ObjectId)
                                       , tmpTo AS (SELECT tmpFrom.GoodsId, SUM (Container.Amount) AS Amount
                                                   FROM tmpFrom
                                                        INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                                            AND Container.WhereObjectId = vbUnitId
                                                                            AND Container.ObjectId = tmpFrom.GoodsId
                                                                            AND Container.Amount > 0
                                                   GROUP BY tmpFrom.GoodsId
                                                  )
                                    SELECT STRING_AGG (tmp.Value, ' (***) ')
                                    FROM (SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '') || ' �����: ' || zfConvert_FloatToString (AmountFrom) || COALESCE (Object_Measure.ValueData, '') || '; �������: ' || zfConvert_FloatToString (AmountTo) || COALESCE (Object_Measure.ValueData, '') AS Value
                                          FROM (SELECT tmpFrom.GoodsId, tmpFrom.Amount AS AmountFrom, COALESCE (tmpTo.Amount, 0) AS AmountTo
                                                FROM tmpFrom
                                                     LEFT JOIN tmpTo ON tmpTo.GoodsId = tmpFrom.GoodsId WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0)) AS tmp
                                               LEFT JOIN Object ON Object.Id = tmp.GoodsId
                                               LEFT JOIN ObjectLink ON ObjectLink.ObjectId = tmp.GoodsId
                                                                   AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure()
                                               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink.ChildObjectId
                                         ) AS tmp
                                    );
        END IF;

        -- ���� �� ���� ������
        IF COALESCE (outMessageText, '') = '' OR vbUserId = 3
        THEN -- ��������� �����
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), inMovementId, vbConfirmedKindId);

             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UserConfirmedKind(), inMovementId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserConfirmedKind(), inMovementId, vbUserId);
        ELSE -- ����� ������ �� �������� ��� ����
             ouConfirmedKindName:= COALESCE ((SELECT Object.ValueData FROM MovementLinkObject AS MLO JOIN Object ON Object.Id = MLO.ObjectId WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_ConfirmedKind()), '');
        END IF;

    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 12.10.18                                                                      *
 18.08.16                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Check_ConfirmedKind (inSession:= zfCalc_UserAdmin())
