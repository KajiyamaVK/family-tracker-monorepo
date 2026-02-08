# Gemini Instructions

This file contains instructions for the Gemini CLI agent to follow when working on this project.

## Deployment

To redeploy the application, use the `deploy` script from `package.json`:

```bash
npm run deploy
```

## Instructions

The user can edit this file to add or change instructions for the Gemini CLI agent.

- **Update Documentation**: Every time we add, remove, or update API endpoints or features, update `README.md` with detailed usage instructions.
- **Bruno Configuration**: The Bruno collection **MUST** be the single source of truth for API documentation. When adding, modifying, or removing API endpoints, you **MUST IMMEDIATELY** update the corresponding Bruno request files. This is not optional.
- **Test Preservation**: When code is not being updated, added, or removed, no content should change in tests. This is a strict shield against LLM mistakes; do not modify existing tests unless the feature they cover is changing.
- **Mandatory Testing**: Every service (added or modified) MUST include both Unit and End-to-End (E2E) tests.
- **Strict TDD**: Always start by developing tests first (TDD). Run tests -> Fail -> Build solution to pass.
- **Joi Validation**: usage of `joi` is MANDATORY for validating all requests coming from the client.

## Vibe Coding & TDD Workflow

We follow "Vibe Coding" principles where the AI acts as an Orchestrator and TDD is the safety net.

### The Workflow
1. **Define Intent (The Blueprint)**
   - Define the interface or requirement first. Do not jump to code.
   - Example: "Define a TypeScript interface for a service that handles..."

2. **Generate Tests First (The Contract)**
   - Write or update a complete test suite defining the expected behavior.
   - Do NOT implement the service yet (or if backfilling, verify behavior).
   - The test suite is the "Contract" that defines success.

3. **The Red-to-Green "Vibe"**
   - Run the tests. Failures reveal the gap.
   - Implement the service/controller to make these specific tests pass.
   - Do not write bloat; only fulfill the contract.

4. **Shadow Technical Debt Prevention**
   - Always check for existing tests before searching for files.
   - Never skip tests for speed.

## Project Structure

- **Mobile App**: The source code for the mobile application is located in `apps/mobile`. tests related to the mobile app should be run from this directory (e.g., `flutter test` inside `apps/mobile`).
