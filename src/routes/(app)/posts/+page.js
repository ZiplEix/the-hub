
export const load = ({ fetch }) => {
    const fetchPost = async () => {
        const res = await fetch('/api/posts')
        const data = await res.json()
        return data.posts
    }

    return {
        posts: fetchPost()
    }
}