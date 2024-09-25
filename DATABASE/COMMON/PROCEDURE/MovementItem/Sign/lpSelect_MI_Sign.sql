-- Function: lpSelect_MI_Sign (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS lpSelect_MI_Sign (Integer);

CREATE OR REPLACE FUNCTION lpSelect_MI_Sign(
    IN inMovementId  Integer       -- ���� ���������
)
RETURNS TABLE (Id             Integer
             , SignInternalId Integer
             , strSign        TVarChar -- ������������ - ����� �����������
             , strSignNo      TVarChar -- ������������ - ����� �� �����������
             , strIdSign      TVarChar -- Id ������������� - ����� �����������
             , strIdSignNo    TVarChar -- Id ������������� - ����� �� �����������
             , strMIIdSign    TVarChar -- Id MovementItem - ����� �����������
             , Count_member   Integer
              )
AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbObjectDescId   Integer;
  DECLARE vbObjectId       Integer;  
  DECLARE vbSignInternalId Integer;
BEGIN
   
     -- ��������� �� ��������� - ��� ����������� <������ ����������� �������>
     SELECT Movement.DescId                                AS MovementDescId
          , COALESCE (Object_To.DescId,0)                  AS ObjectDescId
          , COALESCE (MovementLinkObject_From.ObjectId,0)  AS ObjectId
          , COALESCE (MovementLinkObject.ObjectId, 0)      AS SignInternalId
            INTO vbMovementDescId, vbObjectDescId, vbObjectId, vbSignInternalId
     FROM Movement
          LEFT JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                      AND MovementLinkObject.DescId     = zc_MovementLinkObject_SignInternal()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                      AND Movement.DescId                    = zc_Movement_Income()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                      AND Movement.DescId                    = zc_Movement_Income()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
     WHERE Movement.Id = inMovementId;

     
     -- ���������
     RETURN QUERY 
     
     WITH -- ������ �� ������ ��� ������� ���������
          tmpObject AS (SELECT tmp.Ord, tmp.SignInternalId, tmp.SignInternalName
                             , COALESCE (lpSelect.UserId, tmp.UserId) AS UserId
                             , COALESCE (lpSelect.UserName, tmp.UserName) AS UserName
                             , tmp.isMain
                        FROM lpSelect_Object_SignInternalItem (vbSignInternalId, vbMovementDescId, vbObjectDescId, 0) AS tmp
                             LEFT JOIN lpSelect_Movement_PromoTradeSign (inMovementId) AS lpSelect
                                                                                       ON lpSelect.Num = tmp.Ord
                                                                                      AND vbMovementDescId = zc_Movement_PromoTrade()
                       )
          -- ������ �� ��� ����������� ��������� �������
        , tmpMI AS (SELECT MovementItem.Id                    AS MovementItemId
                           -- !!!������
                         , CASE WHEN vbSignInternalId > 0 THEN vbSignInternalId ELSE MovementItem.ObjectId END AS SignInternalId

                           -- � �/� ��� PromoTrade
                         , MovementItem.Amount                AS Ord
                           --
                         , MILO_Insert.ObjectId               AS UserId
                         , Object_User.ValueData              AS UserName
                    FROM MovementItem 
                         LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                          ON MILO_Insert.MovementItemId = MovementItem.Id
                                                         AND MILO_Insert.DescId         = zc_MILinkObject_Insert()
                         LEFT JOIN Object AS Object_User ON Object_User.Id = MILO_Insert.ObjectId
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Sign()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0
                    ORDER BY MovementItem.Amount
                   )
         -- ��� ��� ��������
       , tmpSign AS (SELECT STRING_AGG (tmpMI.UserName,                   ', ') AS strSign      -- � ��������
                          , STRING_AGG (tmpMI.UserId         :: TVarChar, ',')  AS strIdSign    -- ��� �������
                          , STRING_AGG (tmpMI.MovementItemId :: TVarChar, ',')  AS strMIIdSign  -- ��� �������
                          , tmpMI.SignInternalId
                     FROM tmpMI
                     GROUP BY tmpMI.SignInternalId
                    )
         -- ��� ������� ���������
       , tmpSignNo AS (SELECT STRING_AGG (tmp.UserName,           ', ') AS strSignNo    -- � ��������
                            , STRING_AGG (tmp.UserId :: TVarChar, ',')  AS strIdSignNo  -- ��� �������
                            , tmp.SignInternalId                        AS SignInternalId
                       FROM (SELECT tmpObject.UserName, tmpObject.UserId, tmpObject.SignInternalId
                             FROM tmpObject
                                  LEFT JOIN tmpMI ON tmpMI.UserId         = tmpObject.UserId
                                                 AND tmpMI.SignInternalId = tmpObject.SignInternalId
                                                 AND (tmpMI.Ord           = tmpObject.Ord
                                                   OR vbMovementDescId    <> zc_Movement_PromoTrade()
                                                     )
                             WHERE tmpMI.UserId IS NULL
                             ORDER BY tmpObject.Ord
                             LIMIT CASE WHEN vbMovementDescId = zc_Movement_PromoTrade() THEN 1 ELSE 1000 END
                             ) AS tmp
                       GROUP BY tmp.SignInternalId
                      )
     -- ���������
     SELECT inMovementId                                     AS Id
          , COALESCE (tmpSignNo.SignInternalId, tmpSign.SignInternalId) :: Integer AS SignInternalId
          , COALESCE (tmpSign.strSign, '')       :: TVarChar AS strSign
          , COALESCE (tmpSignNo.strSignNo, '')   :: TVarChar AS strSignNo
          , COALESCE (tmpSign.strIdSign, '')     :: TVarChar AS strIdSign
          , COALESCE (tmpSignNo.strIdSignNo, '') :: TVarChar AS strIdSignNo
          , COALESCE (tmpSign.strMIIdSign, '')   :: TVarChar AS strMIIdSign
          , (SELECT COUNT(*) FROM tmpObject)     :: Integer  AS Count_member
     FROM tmpSign
          FULL JOIN tmpSignNo ON tmpSignNo.SignInternalId = tmpSign.SignInternalId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.08.16         * 

*/

-- ����
-- SELECT * FROM lpSelect_MI_Sign (inMovementId:= 16390310)
