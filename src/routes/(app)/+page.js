export async function load({ fetch }) {
    const res = await fetch("https://jsonplaceholder.typicode.com/posts")
    const subs = await res.json()

    if (res.ok) {
        return {
            subs
        }
    }

    return {
        status: res.status,
        error: new Error("could not fetch subs")
    }
}
