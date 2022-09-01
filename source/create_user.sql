-- Master
CREATE LOGIN ETLUser WITH PASSWORD = '<password>'
CREATE USER ETLUser FOR LOGIN ETLUser

-- SQL dedicated
CREATE USER ETLUser FOR LOGIN ETLUser
EXEC sp_addrolemember 'db_datareader',[ETLUser]
EXEC sp_addrolemember 'db_datawriter',[ETLUser]
EXEC sp_addrolemember 'db_ddladmin',[ETLUser]

--validar resource class existentes (debe aparece el usuario que acabamos de crear)
SELECT RC.name ResourceClass,   
		RCM.name ResourceClassMember
 FROM sys.database_role_members AS DRM  
 RIGHT OUTER JOIN sys.database_principals AS RC  
   ON DRM.role_principal_id = RC.principal_id  
 LEFT OUTER JOIN sys.database_principals AS RCM  
   ON DRM.member_principal_id = RCM.principal_id  
WHERE RC.name like '%ETLUser%';

--listar los workload classifier existentes
SELECT *
  FROM sys.workload_management_workload_classifiers c
  JOIN sys.workload_management_workload_classifier_details cd
    ON cd.classifier_id = c.classifier_id

--creacion del nuevo workload classifier
CREATE WORKLOAD CLASSIFIER [WG_LoadData]
WITH (WORKLOAD_GROUP = 'largerc'
      ,MEMBERNAME = 'ETLUser'
      ,IMPORTANCE = HIGH
	 );

--validar que aparezca el workload classifier que creamos y que en la columna classifier_value esté el usuario
SELECT *
  FROM sys.workload_management_workload_classifiers c
  JOIN sys.workload_management_workload_classifier_details cd
    ON cd.classifier_id = c.classifier_id
  WHERE c.name = 'WG_LoadData'
