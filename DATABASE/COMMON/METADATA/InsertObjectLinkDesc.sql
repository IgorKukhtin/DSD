insert into ObjectLinkDesc(Id, Code, ItemName, ObjectDescId, ChildObjectDescId)
values (zc_ObjectLink_RoleRight_Role(), 'RoleRight_Role', 'Ссылка на роль в справочнике указания ролей', zc_Object_RoleRight(), zc_Object_Role());

insert into ObjectLinkDesc(Id, Code, ItemName, ObjectDescId, ChildObjectDescId)
values (zc_ObjectLink_RoleRight_Process(), 'RoleRight_Process', 'Ссылка на процесс в справочнике указания ролей', zc_Object_RoleRight(), zc_Object_Process());

insert into ObjectLinkDesc(Id, Code, ItemName, ObjectDescId, ChildObjectDescId)
values (zc_ObjectLink_UserRole_Role(), 'UserRole_Role', 'Ссылка на роль в справочнике связи пользователей и ролей', zc_Object_UserRole(), zc_Object_Role());

insert into ObjectLinkDesc(Id, Code, ItemName, ObjectDescId, ChildObjectDescId)
values (zc_ObjectLink_UserRole_User(), 'UserRole_User', 'Связь с пользователем в справочнике ролей пользователя', zc_Object_UserRole(), zc_Object_User());

insert into ObjectLinkDesc(Id, Code, ItemName, ObjectDescId, ChildObjectDescId)
values (zc_ObjectLink_Cash_Currency(), 'Cash_Currency', 'Связь кассы с валютой', zc_Object_Cash(), zc_Object_Currency());

insert into ObjectLinkDesc(Id, Code, ItemName, ObjectDescId, ChildObjectDescId)
values (zc_ObjectLink_Cash_Branch(), 'Cash_Branch', 'Связь кассы с филиалом', zc_Object_Cash(), zc_Object_Branch());
