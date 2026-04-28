# Test case thoughts and reflections

Hello, this README will be where I write my thoughts during the exercice for you to have a better understanding on how I process with things.

## Project overview

First I wanted to have a quick look at the project, one of the first things I saw is that the elixir and erlang version are quite out of date. In a ideal world I would put them up to date, but for this exercice I went with the assumption that this could be a real world example where we can't always have the latests libraries for many various reasons, so I kept the version to what they were.

Another thing that surprised me is that not everything is tested. For example, Ats.Applicants.create_apply/1 which is then used in the Apply controller is not tested.

## First steps

For this exercice, as it concerns an already implemented project, I think it's best to start with the bugs, this way I can get a better grasp of the link between all functions and modules and how the project is architectured. I started with the job visibility bug.

For the git commits, I decided to have one branch per feature or bug, as I would in a real life scenario, at the end of each development, I merged my branches into main.

### 1 - Job visibility

From what I understand, there is two job board, the one served at / endpoint, which serves the public job board, and the one served at /jobs which serves all job boards, only accessible to identified users. So this bug concerns only the public job board accessible at /.

To fix this bug, I simply created a new function to the jobs module which fetch all jobs with a specific status, this way it could be used for other status in the future if we want to implement a filter or something similar. I hesitated with the naming betwing list_jobs/1 to get a continuity with list_jobs/0 and list_jobs_with_status/1. In the end I chose list_jobs_with_status/1 as I don't know the best practices used at wttj and I think having a name stating clearly what is done in the function is best for understanding purposes.

### 2 - Deleting job postings

For this bug, I think a migration to modify the behaviour on job delete could do the trick, for this I would need to modify the constraints in the table applicants on job_id foreign key to have on_delete: :delete_all instead of on_delete: :nothing. One thing I find strange is that for the Candidate table, there is a one_to_many on applicants and applicants/jobs, meaning that one Candidate could theoratically apply to multiple job offers, however I didn't find a way to do this in the interface or in the code, so I'm not sure if when we delete a job offer and all linked applicants we should also delete all linked candidates. For now I chose not to as we can delete candidates directly on the interface and we can see them without the link to the applicant.

Another option would have been to keep the applicant and have the job_id foreign key set to nil on job deletion, I chose to delete the applicant as well to not keep useless data to not clog the database and to avoid keeping unused data for too long as there is no way from the interface to see applicants apart from the job offer, so if we delete a job we can't access the applicants if we keep them.

### 3 - Application duplication

For this bug, I find the wording strange, as it's mentionned that an user can apply to the same job multiple times, however, when logged in as an user we cannot apply as this user, the only way to apply creates a new candidate, so I'll assume that "User" means "Candidate" in this context.
From what I understand, we can't reuse the same Candidate to apply to multiple job from the interface, when we apply to another job offer, we have to reenter all data which will create a new Applicant and a new Candidate. 
So for this bug, I think we have to identify a candidate by some data, a common way would be to identify the candidate from it's email and it's phone number.

To handle this, I added a unique constraint on candidate phone number/jobs id or candidate email/jobs id pairs in the Apply changeset, which is then used to create both the candidate and the applicant.

## Feature

For this exercice, I chose to implement the Application notification feature.

The first thing to do is to implement a way to know which job offer belongs to which user, for this I implemented a has_many relationship between users and jobs.

For the email sending implementation, I chose to not implement it in the Ats.Accounts.UserNotifier module, as for me, this should be reserved to any Account notification and not Application notification, which is a separate business logic. Instead I implemented it in the Ats.Applicants.ApplicationNotifier that I created under Ats.Applicants namespace, as for me this is more tied to Applicants.

I used Swoosh as it's the one already used in the application, we use the Local Swoosh Mailer which doesn't have the complexity a real mailer could have, like errors due to network, recipient not found, quota reached, etc.

I used a simple Task Supervisor to send emails asynchronously and to let it handle concurrency in case of high demand if there is a thousand application at the same time. This has some limitation as the number of retries is within a limited time frame, so if in a prod scenario we have emails sending failure due to some connectivity issue or bottleneck, it could retry forever if the amount is not reached or simply stop retrying at the first error if too many errors occurs. 

Also, we can't have different retries behaviour depending on the error, for exemple to not retry if the recipient is not found, or wait a bit if the email quota is reached, but as we're using a local mailer for this exercice, I prefered to keep it simple, a solution would have been to use a GenServer and handle each child failure case, or to not let the process crash and retry based on what is returned by Mailer.deliver: we're currently only matching on {:ok, _metadata}, but we could have matched on {:error, :recipient_not_found} and fail or {:error, :timeout} and retry by calling the same function with a max number of retry parameters.

Another addition could have been to add a new column to the Applicant table which would be a boolean to save the fact that we sent the email or not. This would allow to handle Application crash or reboot for deployment, this way, at application startup we could lookup all applicants without email sent and send the email for them.

## Use of AI

For this project I had a limited use of AI, mainly to autocomplete and to ask for some basic questions like I would with Google, like how to call this Elixir library, or what is the difference beetween two Elixir functions, or what happens if I do this differently. But it was mostly a complement of the Elixir documentation, which is quite sufficient on it's own.

I prefered to keep it this way to be sure I understand what I'm doing and not be entirely dependent on the AI solution as this is an exercice to test my approach and how I handle things.

## After thoughts

Overall the exercice was quite intersting, it was challenging to have a 48 hour constraint as it meant I had to do some choices in how I handled things and that I couldn't add all features. I still chose to resolve all bugs as it was a way to get a good grasp of the whole project and the coding practices.

I was surprised to see that the elixir and phoenix version are not up to date, I decided to leave their version as it is, as it's frequent to have to work with older version of libraries on real life project as updating them can be sensitive for production environment.

Another thing that surprised me is that there is tests for all getter/setter but not much tests for the other functions that are used by the controllers, like the Applicants.create_apply/1 function.

If there is something that I could have done differently, is to have implemented a GenServer for the Application Notification to better handle concurrency and retries. I would have also liked to add more tests as I stayed with the "happy path" testing without testing edge cases in great variety due to the time constraint, but as the function in this exercice are quite simple, I don't think it's an issue. If for the mailer it could return something else than {:ok, metadata}, which is not the case for the Swoosh Local Mailer, it would have been great to test each failure case to verify that they are handled properly.

I hope you find my solution as interesting as I found this exercice.

Nicolas Dejonghe