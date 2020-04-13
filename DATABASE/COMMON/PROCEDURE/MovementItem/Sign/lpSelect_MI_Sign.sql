-- Function: lpSelect_MI_Sign (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS lpSelect_MI_Promo_Sign (Integer);
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
              )
AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbSignInternalId Integer;
BEGIN
   
     -- ��������� �� ��������� - ��� ����������� <������ ����������� �������>
     SELECT Movement.DescId                           AS MovementDescId
          , COALESCE (MovementLinkObject.ObjectId, 0) AS SignInternalId
            INTO vbMovementDescId, vbSignInternalId
     FROM Movement
          LEFT JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                      AND MovementLinkObject.DescId     = zc_MovementLinkObject_SignInternal()
     WHERE Movement.Id = inMovementId;

     
     -- ���������
     RETURN QUERY 
     
     WITH -- ������ �� ������ ��� ������� ���������
          tmpObject AS (SELECT *
                        FROM lpSelect_Object_SignInternalItem (vbSignInternalId, vbMovementDescId, 0, 0) AS tmp
                      --WHERE tmp.SignInternalId = vbSignInternalId
                      --   OR (COALESCE (vbSignInternalId,0) = 0 AND tmp.isMain = TRUE)
                        )
          -- ������ �� ��� ����������� ��������� �������
        , tmpMI AS (SELECT MovementItem.Id                    AS MovementItemId
                         , MovementItem.ObjectId              AS SignInternalId
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
                             WHERE tmpMI.UserId IS NULL
                             ORDER BY tmpObject.Ord
                             ) AS tmp
                       GROUP BY tmp.SignInternalId
                      )
     -- ���������
     SELECT inMovementId                      AS Id
          , COALESCE (tmpSignNo.SignInternalId, tmpSign.SignInternalId) :: Integer AS SignInternalId
          , tmpSign.strSign       :: TVarChar AS strSign
          , tmpSignNo.strSignNo   :: TVarChar AS strSignNo
          , tmpSign.strIdSign     :: TVarChar AS strIdSign
          , tmpSignNo.strIdSignNo :: TVarChar AS strIdSignNo
          , tmpSign.strMIIdSign   :: TVarChar AS strMIIdSign
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
-- SELECT * FROM lpSelect_MI_Sign (inMovementId:= 15644701)
