# Technical Test for Backend Developer - Application Tracking System

Welcome to the Backend Developer Job Application Tracking System! This application, built with Elixir Phoenix, is designed to assist in conducting technical tests for backend developer candidates.

This application is a simplified job board.
A unregistered user is able to list all jobs and can apply to a job.
It provides a platform to manage job offers and track candidate information.

A registered user can create, edit, and delete job offers.
On each job offer, a registered user can see the list of candidates who have applied to the job.

## Installation

1. Clone the repository
2. Navigate to the project directory: `cd technical-test-backend`
3. Install languages versions and dependencies:

    We suggest you use asdf (or another version manager) to manage Erlang, Elixir, and NodeJS versions.

    To install asdf, visit http://asdf-vm.com/guide/getting-started.html.

    Add the 3 plugins:

    ```
    asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
    asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
    asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    ```

    Then install the versions specified in the `.tool-versions` file:

    ```
    asdf install
    ```

    You can now install the Elixir dependencies:

    ```
    mix deps.get
    ```
4. Set up the database (MySQL/PostgreSQL/MongoDB) and update the configuration in `config/dev.exs` or start a Docker container with the `docker-compose.yml` file included in the project.
5. Create and migrate the database: `mix ecto.setup`
6. Run the tests: `mix test`
7. Start the Phoenix server: `mix phx.server`

## Exercise

We are glad to introduce you to this technical test which will help us better understand your skills and competencies related to our tech stack. In this exercise, we will use our in-house built Applicant Tracking System (ATS) application developed with Phoenix Elixir.

The goal of this test is to simulate real-world scenarios where you will need to add new features to an existing application and fix some bugs. You have to implement at least 1 feature and 1 bug fix. Your work will be evaluated based on your approach, your understanding of the problem and the quality of your code.

### Features

Here are three potential features you could add:

1. **Job search function:** Add a feature that allows all users to search for jobs. This should include being able to search using various parameters like job title, office, work_mode, etc. You have to implement the backend functionality, the frontend UI is optional.

2. **Modification log:** Implement a change log for each job update. The system should keep track of who made a modification, as well as the fields and values that were changed. You have to implement the backend functionality, the frontend UI is optional.

3. **Application notifications:** Whenever a user applies for a job, the job's creator should receive an email notifying them of this new application. You do not need to actually send an email in the development environment. It is sufficient to simulate or mock this functionality in some way.

### Bugs

Here are some bugs you might fix:

1. **Job visibility:** Currently, all job postings are visible to all users, regardless of their status. The expected behavior is that only job postings with a status of "published" should be visible to non-logged in users.

2. **Deleting job postings:** As a recruiter (registered user), it is currently impossible to delete a job posting if someone has already applied. We want recruiters to have the ability to delete a job posting, even if there are applicants.

3. **Application duplication:** Users are currently able to apply to the same job multiple times. We need to implement a restriction to prevent multiple applications to the same job by the same user.

### Notes

Take your time and remember, the main goal here is to demonstrate your abilities, so we suggest you choose feature(s) and bugfix(es) that you feel most confident to implement given your skills and experience.

Happy coding and good luck!
