@ECHO OFF
SETLOCAL
SET DIRNAME=%~dp0
SET APP_BASE_NAME=%~n0
SET APP_HOME=%DIRNAME%
SET DEFAULT_JVM_OPTS=

java %DEFAULT_JVM_OPTS% %JAVA_OPTS% %GRADLE_OPTS% -cp "%APP_HOME%\gradle\wrapper\gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain %*
