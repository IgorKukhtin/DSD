-- View: Object_MemberPriceList_View

-- DROP VIEW IF EXISTS Object_MemberPriceList_View;

CREATE OR REPLACE VIEW Object_MemberPriceList_View
AS
  SELECT
         Object_MemberPriceList.Id          AS Id
       , Object_User.Id                     AS UserId
       , Object_User.ValueData              AS UserName
       , Object_PriceList.Id                AS PriceListId
       , Object_PriceList.ObjectCode        AS PriceListCode
       , Object_PriceList.ValueData         AS PriceListName
       , Object_Member.Id                   AS MemberId
       , Object_Member.ObjectCode           AS MemberCode
       , Object_Member.ValueData            AS MemberName
       , Object_MemberPriceList.isErased    AS isErased

  FROM Object AS Object_MemberPriceList

       LEFT JOIN ObjectLink AS ObjectLink_MemberPriceList_PriceList
                            ON ObjectLink_MemberPriceList_PriceList.ObjectId = Object_MemberPriceList.Id
                           AND ObjectLink_MemberPriceList_PriceList.DescId   = zc_ObjectLink_MemberPriceList_PriceList()
       LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_MemberPriceList_PriceList.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_MemberPriceList_Member
                            ON ObjectLink_MemberPriceList_Member.ObjectId = Object_MemberPriceList.Id
                           AND ObjectLink_MemberPriceList_Member.DescId   = zc_ObjectLink_MemberPriceList_Member()
       LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_MemberPriceList_Member.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ChildObjectId = ObjectLink_MemberPriceList_Member.ChildObjectId
                           AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
       LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_User_Member.ObjectId

  WHERE Object_MemberPriceList.DescId   = zc_Object_MemberPriceList()
    AND Object_MemberPriceList.isErased = FALSE
 ;


ALTER TABLE Object_MemberPriceList_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 05.05.21                                        *

*/

-- ÚÂÒÚ
-- SELECT * FROM Object_MemberPriceList_View
