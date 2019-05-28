xposed module to pretend the app was signed by the other developer.

Works by hoking android.app.AppPackageManager


Install orriginal app A with with proper sig.
Save signature by clicking on the app A. After this step the orig app A can be deleted.
Install modified/another app B with wrong signature.
Tap on saved app A.
Select app B

UI is ugly and not intuitive, but hey, its one hour hackathon and it is free :__)
