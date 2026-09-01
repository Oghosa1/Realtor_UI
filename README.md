# ExpertListing Assessment

## 1. Overview
This project is a submission for the ExpertListing take-home assessment. It consists of a Flutter mobile client that communicates with a REST API backend. The implementation focuses on providing a responsive, feed-based experience with post creation and engagement functionality.

## 2. Implemented Features
The following features are fully implemented and working in the mobile application:
- Feed display with multiple post categories
- Feed filtering (All, Requests, General, Properties)
- Story viewing (horizontal scroll)
- Post creation (with content, category, transaction tag, location, and image upload)
- Like post (optimistic UI update)
- Bookmark post (frontend state only)
- Image loading states (custom animated shimmer skeletons)
- Error handling and network timeout recovery
- Pagination (load more)

## 3. Architecture
The application follows a standard client-server architecture:

```text
Flutter App (Mobile Client)
    |
    |  REST API (JSON / Multipart Form-Data)
    v
Backend API (Node.js)
    |
    +---- PostgreSQL (Data Persistence)
    |
    +---- Cloudinary (Image Storage)
```

## 4. Frontend Implementation
The Flutter mobile application is structured around the **MVVM (Model-View-ViewModel)** architectural pattern.
- **State Management**: Uses `flutter_riverpod` (`AutoDisposeAsyncNotifier`) to manage asynchronous feed state, pagination, and optimistic UI updates.
- **Networking**: Built on `dio` with interceptors for request inspection and custom headers (e.g., `x-user-id`).
- **Navigation**: Uses `go_router` for route management.
- **Image Handling**: Utilizes `cached_network_image` for caching and `image_picker` for selecting media.
- **Loading States**: Custom `ShimmerSkeleton` widgets provide a professional loading experience without relying on heavy external packages.
- **Error Handling**: Network errors and timeouts are caught at the service layer and surfaced to the UI via Riverpod's `AsyncValue.error`.

## 5. Backend Implementation
*(Note: The backend repository is managed separately. The following reflects the API contract consumed by the mobile app.)*

The backend provides a RESTful API that handles feed queries, pagination, and post creation. It processes `multipart/form-data` for image uploads, interfaces with Cloudinary for media storage, and persists structured data in PostgreSQL. 

## 6. API Endpoints
The mobile client currently integrates with the following backend endpoints:

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/stories` | Retrieves the list of active user stories. |
| `GET` | `/posts` | Retrieves the paginated feed. Accepts `page`, `limit`, and `category` query parameters. |
| `POST` | `/posts` | Creates a new post. Accepts `multipart/form-data` for content, tags, location, and an optional image. |
| `POST` | `/posts/:id/like` | Toggles the like status of a specific post for the current user. |
| `GET` | `/posts/:id/comments` | Retrieves comments for a specific post. |
| `POST` | `/posts/:id/comments` | Adds a new comment to a post. |

## 7. Database Schema
Based on the data contracts in the Flutter models (`PostModel`, `StoryModel`, `UserModel`, `CommentModel`), the PostgreSQL database models the following core entities:

- **Users**: Core user profiles (ID, name, avatar, verification status).
- **Posts**: Feed content (author relation, category, tags, content, location, media URL, engagement counts).
- **Comments**: Replies to posts (post relation, author relation, text content, timestamp).
- **Stories**: Ephemeral content (author relation, media, view status).

## 8. Image Upload
1. The user selects an image from their device gallery using the `image_picker` plugin.
2. The image is packaged into a `FormData` object using `MultipartFile.fromFile`.
3. The mobile app sends a `POST` request to `/posts` containing the image and text fields.
4. The backend receives the file, uploads it to **Cloudinary**, and stores the resulting secure URL in the PostgreSQL database.
5. When querying the feed, the mobile app receives the Cloudinary URL and renders it using `CachedNetworkImage`.

## 9. Pagination
The feed uses **offset-based pagination**. The `GET /posts` endpoint accepts `page` and `limit` query parameters. The Flutter `FeedNotifier` manages the current page state and automatically fetches the next page (`currentPage + 1`) when the user scrolls near the bottom of the feed.

## 10. Error Handling
- **API Requests**: The `FeedService` catches `DioException` types. Connection timeouts and missing internet connections throw specific, user-friendly messages.
- **Backend Responses**: The client parses non-200 HTTP status codes and attempts to extract error messages from the JSON payload (e.g., `{"error": "Failed to upload image"}`).
- **Frontend**: Optimistic UI updates (like toggling a "Like") are automatically reverted if the subsequent API call fails, preventing the UI from falling out of sync with the database.

## 11. Running Locally

### Flutter Mobile App
**Prerequisites**: Flutter SDK (compatible with dart `^3.11.5`).

1. Navigate to the Flutter project directory.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application on an emulator or physical device:
   ```bash
   flutter run
   ```

## 12. Environment Variables
The mobile application currently relies on a hardcoded `AppConstants.apiBaseUrl` and `AppConstants.defaultUserId` for simplicity during the assessment. No `.env` file configuration is required to build the Flutter app.

## 13. Deployment
Deployment configurations (Docker, CI/CD, hosting) were not configured as they were out of scope for the mobile implementation phase.

## 14. Assessment Scope and Assumptions
The implementation was intentionally kept strictly within the scope of the provided assessment parameters.

- **Authentication**: A full authentication flow was explicitly out of scope. The app assumes a logged-in state by passing a hardcoded `x-user-id` header in the API client (`FeedService`).
- **Bookmarks**: The bookmarking feature is implemented visually using optimistic UI updates, but does not hit a backend endpoint as the API route was not prioritized.
- **Figma Design**: The implementation focuses on achieving pixel-perfect fidelity for the feed, bottom navigation, and post composer.

## 15. What Was Skipped
- Payments and wallet integrations.
- Email verification flows.
- Full authentication state management.

## 16. Known Limitations
- Bookmarks are not persisted across app restarts (frontend-only state).
- The user profile is hardcoded to a mock user.

## 18. Technical Decisions
- **State Management**: Selected `Riverpod` for its robust handling of asynchronous data (`AsyncValue`) and dependency injection, which keeps the widget tree clean and declarative.
- **Optimistic UI**: Implemented optimistic updates for "Likes" to ensure the app feels highly responsive, hiding network latency from the user.
- **Shimmer Skeletons**: Built a custom `AnimationController`-based shimmer effect to avoid adding heavy third-party packages, adhering to strict dependency guidelines.
- **Network Client**: Chose `Dio` over `http` for its built-in support for interceptors, timeout configurations, and simplified `FormData` creation for image uploads.

## 19. Assessment Submission
- **GitHub Repository**: [Insert Link]
- **Live Backend**: [Insert Link]
- **Mobile Build**: [Insert Link]
- **Demo Video**: [Insert Link]
