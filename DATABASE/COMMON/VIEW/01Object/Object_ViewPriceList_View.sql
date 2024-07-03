-- View: Object_ViewPriceList_View

-- DROP VIEW IF EXISTS Object_ViewPriceList_View;

CREATE OR REPLACE VIEW Object_ViewPriceList_View
AS
  SELECT
         Object_ViewPriceList.Id            AS Id
       , Object_User.Id                     AS UserId
       , Object_User.ValueData              AS UserName
       , Object_PriceList.Id                AS PriceListId
       , Object_PriceList.ObjectCode        AS PriceListCode
       , Object_PriceList.ValueData         AS PriceListName
       , Object_Member.Id                   AS MemberId
       , Object_Member.ObjectCode           AS MemberCode
       , Object_Member.ValueData            AS MemberName
       , Object_ViewPriceList.isErased      AS isErased

  FROM Object AS Object_ViewPriceList

       LEFT JOIN ObjectLink AS ObjectLink_ViewPriceList_PriceList
                            ON ObjectLink_ViewPriceList_PriceList.ObjectId = Object_ViewPriceList.Id
                           AND ObjectLink_ViewPriceList_PriceList.DescId   = zc_ObjectLink_ViewPriceList_PriceList()
       LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_ViewPriceList_PriceList.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_ViewPriceList_Member
                            ON ObjectLink_ViewPriceList_Member.ObjectId = Object_ViewPriceList.Id
                           AND ObjectLink_ViewPriceList_Member.DescId   = zc_ObjectLink_ViewPriceList_Member()
       LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_ViewPriceList_Member.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ChildObjectId = ObjectLink_ViewPriceList_Member.ChildObjectId
                           AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
       LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_User_Member.ObjectId

  WHERE Object_ViewPriceList.DescId   = zc_Object_ViewPriceList()
    AND Object_ViewPriceList.isErased = FALSE
 ;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 23.06.24                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_ViewPriceList_View
